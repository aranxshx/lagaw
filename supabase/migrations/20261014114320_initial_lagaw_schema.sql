-- S1-01: application schema from docs/pitch.md, section 3.
-- Durations are minutes; money is PHP; day/order numbers start at 1.

create table public.users (
    id uuid primary key default gen_random_uuid(),
    name text not null check (btrim(name) <> ''),
    email text not null unique check (btrim(email) <> ''),
    traveler_type text,
    preferred_tags text[] not null default '{}',
    default_budget_min numeric(12,2),
    default_budget_max numeric(12,2),
    created_at timestamptz not null default now(),

    constraint users_budget_min_nonnegative
        check (default_budget_min >= 0 and default_budget_min < 'Infinity'::numeric),
    constraint users_budget_max_nonnegative
        check (default_budget_max >= 0 and default_budget_max < 'Infinity'::numeric),
    constraint users_budget_order
        check (default_budget_min <= default_budget_max)
);

create table public.locations (
    id uuid primary key default gen_random_uuid(),
    name text not null check (btrim(name) <> ''),
    description text,
    category text not null check (btrim(category) <> ''),
    vibe_tags text[] not null default '{}',
    address text,
    latitude numeric(9,6),
    longitude numeric(9,6),
    opening_hours jsonb not null default '{}',
    estimated_cost_min numeric(12,2),
    estimated_cost_max numeric(12,2),
    typical_visit_duration integer,
    suitable_group_types text[] not null default '{}',
    image_url text,
    is_active boolean not null default true,

    constraint locations_latitude_range
        check (latitude between -90 and 90),
    constraint locations_longitude_range
        check (longitude between -180 and 180),
    constraint locations_coordinates_pair
        check ((latitude is null) = (longitude is null)),
    constraint locations_opening_hours_object
        check (jsonb_typeof(opening_hours) = 'object'),
    constraint locations_cost_min_nonnegative
        check (estimated_cost_min >= 0 and estimated_cost_min < 'Infinity'::numeric),
    constraint locations_cost_max_nonnegative
        check (estimated_cost_max >= 0 and estimated_cost_max < 'Infinity'::numeric),
    constraint locations_cost_order
        check (estimated_cost_min <= estimated_cost_max),
    constraint locations_visit_duration_positive
        check (typical_visit_duration > 0)
);

-- Each row is an event; multiple events for one user/location are allowed.
create table public.user_location_interactions (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references public.users(id) on delete cascade,
    location_id uuid not null references public.locations(id) on delete restrict,
    interaction_type text not null,
    interaction_value numeric not null,
    rating_value numeric,
    created_at timestamptz not null default now(),

    constraint interactions_type_valid
        check (interaction_type in ('left_swipe', 'right_swipe', 'save', 'rating')),
    constraint interactions_value_finite
        check (interaction_value > '-Infinity'::numeric
            and interaction_value < 'Infinity'::numeric),
    constraint interactions_rating_finite
        check (rating_value > '-Infinity'::numeric and rating_value < 'Infinity'::numeric),
    constraint interactions_rating_presence
        check (
            (interaction_type = 'rating' and rating_value is not null)
            or (interaction_type <> 'rating' and rating_value is null)
        )
);

create table public.trips (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references public.users(id) on delete cascade,
    title text not null check (btrim(title) <> ''),
    start_date date not null,
    end_date date not null,
    budget_min numeric(12,2) not null,
    budget_max numeric(12,2) not null,
    transportation_mode text,
    group_type text,
    preferred_tags text[] not null default '{}',
    status text not null default 'draft' check (btrim(status) <> ''),
    estimated_total_cost numeric(12,2),

    constraint trips_date_order check (end_date >= start_date),
    constraint trips_budget_min_nonnegative
        check (budget_min >= 0 and budget_min < 'Infinity'::numeric),
    constraint trips_budget_max_nonnegative
        check (budget_max >= 0 and budget_max < 'Infinity'::numeric),
    constraint trips_budget_order check (budget_min <= budget_max),
    constraint trips_total_cost_nonnegative
        check (estimated_total_cost >= 0 and estimated_total_cost < 'Infinity'::numeric)
);

create table public.itinerary_items (
    id uuid primary key default gen_random_uuid(),
    trip_id uuid not null references public.trips(id) on delete cascade,
    location_id uuid not null references public.locations(id) on delete restrict,
    day_number integer not null,
    visit_order integer not null,
    arrival_time time,
    departure_time time,
    estimated_travel_time integer,
    estimated_cost numeric(12,2),
    recommendation_score numeric,
    recommendation_reason text,

    constraint itinerary_day_positive check (day_number > 0),
    constraint itinerary_order_positive check (visit_order > 0),
    constraint itinerary_travel_time_nonnegative check (estimated_travel_time >= 0),
    constraint itinerary_cost_nonnegative
        check (estimated_cost >= 0 and estimated_cost < 'Infinity'::numeric),
    constraint itinerary_score_finite
        check (recommendation_score > '-Infinity'::numeric
            and recommendation_score < 'Infinity'::numeric),
    constraint itinerary_position_unique unique (trip_id, day_number, visit_order)
);

-- Index every foreign-key lookup. The itinerary uniqueness index covers trip_id.
create index trips_user_id_idx on public.trips(user_id);
create index interactions_user_location_idx
    on public.user_location_interactions(user_id, location_id);
create index interactions_location_id_idx on public.user_location_interactions(location_id);
create index itinerary_items_location_id_idx on public.itinerary_items(location_id);

-- Flutter calls FastAPI. Client roles do not access application tables directly.
alter table public.users enable row level security;
alter table public.locations enable row level security;
alter table public.user_location_interactions enable row level security;
alter table public.trips enable row level security;
alter table public.itinerary_items enable row level security;

revoke all privileges on table
    public.users, public.locations, public.user_location_interactions,
    public.trips, public.itinerary_items
from public, anon, authenticated;

-- This server role bypasses RLS. FastAPI must enforce ownership/admin permissions.
grant usage on schema public to service_role;
grant select, insert, update, delete on table
    public.users, public.locations, public.user_location_interactions,
    public.trips, public.itinerary_items
to service_role;
