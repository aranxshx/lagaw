"""Lagaw's FastAPI entry point."""

import os
from typing import Annotated

from fastapi import Depends, FastAPI, Query, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from app.database import DatabaseUnavailable, LocationDatabase, get_database
from app.schemas import LocationsPage

app = FastAPI(title="Lagaw API", version="0.1.0")

# The Flutter Web app calls this API from the browser. Allow the production and
# preview sites on Cloudflare Pages and local development servers; extra origins
# can be added with CORS_ALLOW_ORIGINS (comma-separated). The API is read-only.
CORS_ORIGIN_REGEX = (
    r"https://([a-z0-9-]+\.)?lagaw\.pages\.dev"
    r"|https?://(localhost|127\.0\.0\.1)(:\d+)?"
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        origin.strip()
        for origin in os.environ.get("CORS_ALLOW_ORIGINS", "").split(",")
        if origin.strip()
    ],
    allow_origin_regex=CORS_ORIGIN_REGEX,
    allow_methods=["GET"],
    allow_headers=["*"],
)


@app.exception_handler(DatabaseUnavailable)
async def database_unavailable(request: Request, exc: DatabaseUnavailable) -> JSONResponse:
    return JSONResponse(
        status_code=503,
        content={"detail": "Locations are temporarily unavailable. Please try again later."},
    )


@app.get("/locations", response_model=LocationsPage, tags=["locations"], responses={
    503: {"description": "Database configuration, connectivity, or response failure"},
})
def list_locations(
    database: Annotated[LocationDatabase, Depends(get_database)],
    limit: Annotated[int, Query(ge=1, le=100)] = 10,
    offset: Annotated[int, Query(ge=0)] = 0,
) -> LocationsPage:
    """List active destinations, ordered by name and UUID, from PostgreSQL."""
    return LocationsPage(
        items=database.list_locations(limit, offset), limit=limit, offset=offset,
    )
