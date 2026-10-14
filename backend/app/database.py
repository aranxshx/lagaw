"""Backend-only reads from Supabase's PostgreSQL-backed Data API."""

import os
from collections.abc import Iterator
from pathlib import Path
from urllib.parse import urlsplit

import httpx
from dotenv import load_dotenv
from pydantic import TypeAdapter

from app.schemas import Location

ROOT = Path(__file__).resolve().parents[2]
LOCATION_COLUMNS = ",".join(Location.model_fields)
LOCATION_LIST = TypeAdapter(list[Location])


class DatabaseUnavailable(Exception):
    """A safe failure boundary; provider details and credentials stay private."""


class LocationDatabase:
    def __init__(self, client: httpx.Client):
        self.client = client

    def list_locations(self, limit: int, offset: int) -> list[Location]:
        try:
            response = self.client.get(
                "locations",
                params={
                    "select": LOCATION_COLUMNS,
                    "is_active": "eq.true",
                    "order": "name.asc,id.asc",
                    "limit": limit,
                    "offset": offset,
                },
            )
            response.raise_for_status()
            locations = LOCATION_LIST.validate_json(response.content)
            # Reject a malformed response rather than expose inactive destinations.
            if len(locations) > limit or any(not item.is_active for item in locations):
                raise ValueError
            return locations
        except (httpx.HTTPError, ValueError):
            raise DatabaseUnavailable from None


def get_database() -> Iterator[LocationDatabase]:
    load_dotenv(ROOT / ".env", override=False)
    url = os.environ.get("SUPABASE_URL", "").strip().rstrip("/")
    key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY", "").strip()
    try:
        parsed = urlsplit(url)
        local_http = parsed.scheme == "http" and parsed.hostname in ("localhost", "127.0.0.1")
        if (
            not key or not parsed.hostname
            or (parsed.scheme != "https" and not local_http)
            or parsed.username or parsed.password or parsed.path
            or parsed.query or parsed.fragment
        ):
            raise ValueError
        headers = {"apikey": key, "Accept": "application/json", "Accept-Profile": "public"}
        # New sb_secret_ keys belong in apikey, not in a JWT Authorization header.
        if not key.startswith("sb_secret_"):
            headers["Authorization"] = f"Bearer {key}"
        client = httpx.Client(
            base_url=f"{url}/rest/v1/", headers=headers, timeout=10.0,
            follow_redirects=False,
        )
    except (ValueError, httpx.HTTPError, httpx.InvalidURL):
        raise DatabaseUnavailable from None
    with client:
        yield LocationDatabase(client)
