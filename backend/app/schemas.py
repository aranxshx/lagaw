"""Public location responses. Unknown source values remain null or empty objects."""

from uuid import UUID

from pydantic import BaseModel, ConfigDict, Field


class Location(BaseModel):
    model_config = ConfigDict(extra="forbid", allow_inf_nan=False)

    id: UUID
    name: str = Field(min_length=1)
    description: str | None
    category: str = Field(min_length=1)
    vibe_tags: list[str]
    address: str | None
    latitude: float | None = Field(ge=-90, le=90)
    longitude: float | None = Field(ge=-180, le=180)
    opening_hours: dict[str, list[dict[str, str]]]
    estimated_cost_min: float | None = Field(ge=0)
    estimated_cost_max: float | None = Field(ge=0)
    typical_visit_duration: int | None = Field(gt=0)
    suitable_group_types: list[str]
    image_url: str | None
    is_active: bool


class LocationsPage(BaseModel):
    items: list[Location]
    limit: int
    offset: int
