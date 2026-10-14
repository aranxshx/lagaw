"""Lagaw's FastAPI entry point."""

from typing import Annotated

from fastapi import Depends, FastAPI, Query, Request
from fastapi.responses import JSONResponse

from app.database import DatabaseUnavailable, LocationDatabase, get_database
from app.schemas import LocationsPage

app = FastAPI(title="Lagaw API", version="0.1.0")


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
