-- Run as the database owner with psql -v ON_ERROR_STOP=1 -f this_file.sql.
-- All test fixtures and temporary helpers are rolled back.
begin;

create function pg_temp.expect_error(statement text, expected_state text)
returns void language plpgsql as $function$
begin
    begin
        execute statement;
    exception when others then
        if sqlstate = expected_state then
            return;
        end if;
        raise;
    end;
    raise exception 'Expected SQLSTATE %, but statement succeeded: %', expected_state, statement;
end;
$function$;

do $test$
declare
    fixture_user uuid;
    fixture_location uuid;
    fixture_trip uuid;
    fixture_item uuid;
    missing_id uuid := gen_random_uuid();
    fixture_email text := gen_random_uuid()::text || '@example.invalid';
    result_count integer;
    table_name text;
    client_role text;
    operation text;
begin
    insert into public.users (name, email)
    values ('Smoke Traveler', fixture_email) returning id into fixture_user;
    if not exists (
        select 1 from public.users where id = fixture_user
            and preferred_tags = '{}'::text[] and created_at is not null
            and default_budget_min is null and default_budget_max is null
    ) then
        raise exception 'Profile defaults are incorrect';
    end if;

    insert into public.locations (name, category, latitude, longitude)
    values ('Smoke Destination', 'cafe', 10.6765, 122.9509)
    returning id into fixture_location;
    if not exists (
        select 1 from public.locations where id = fixture_location
            and is_active and vibe_tags = '{}'::text[]
            and suitable_group_types = '{}'::text[] and opening_hours = '{}'::jsonb
    ) then
        raise exception 'Location defaults are incorrect';
    end if;

    insert into public.trips (
        user_id, title, start_date, end_date, budget_min, budget_max
    ) values (fixture_user, 'Smoke Trip', '2026-10-19', '2026-10-20', 0, 500)
    returning id into fixture_trip;
    if not exists (
        select 1 from public.trips where id = fixture_trip
            and status = 'draft' and estimated_total_cost is null
    ) then
        raise exception 'Trip defaults are incorrect';
    end if;

    insert into public.itinerary_items (
        trip_id, location_id, day_number, visit_order, estimated_cost
    ) values (fixture_trip, fixture_location, 1, 1, 150)
    returning id into fixture_item;

    insert into public.user_location_interactions (
        user_id, location_id, interaction_type, interaction_value
    ) values
        (fixture_user, fixture_location, 'left_swipe', -1),
        (fixture_user, fixture_location, 'right_swipe', 1),
        (fixture_user, fixture_location, 'right_swipe', 1),
        (fixture_user, fixture_location, 'save', 2);
    insert into public.user_location_interactions (
        user_id, location_id, interaction_type, interaction_value, rating_value
    ) values (fixture_user, fixture_location, 'rating', 3, 4.5);

    select count(*) into result_count
    from public.users u
    join public.trips t on t.user_id = u.id
    join public.itinerary_items i on i.trip_id = t.id
    join public.locations l on l.id = i.location_id
    where u.id = fixture_user and l.id = fixture_location;
    if result_count <> 1 then
        raise exception 'User/trip/itinerary/location relationship failed';
    end if;

    update public.trips set title = 'Updated Trip', status = 'archived'
    where id = fixture_trip;
    if not exists (
        select 1 from public.trips where id = fixture_trip
            and title = 'Updated Trip' and status = 'archived'
    ) then
        raise exception 'Trip update/archive failed';
    end if;

    -- FK failures, required fields, and unique email/itinerary positions.
    perform pg_temp.expect_error(format(
        'update public.trips set user_id = %L where id = %L', missing_id, fixture_trip
    ), '23503');
    perform pg_temp.expect_error(format(
        'update public.itinerary_items set trip_id = %L where id = %L', missing_id, fixture_item
    ), '23503');
    perform pg_temp.expect_error(format(
        'update public.itinerary_items set location_id = %L where id = %L', missing_id, fixture_item
    ), '23503');
    perform pg_temp.expect_error(format(
        'update public.user_location_interactions set user_id = %L where user_id = %L',
        missing_id, fixture_user
    ), '23503');
    perform pg_temp.expect_error(format(
        'update public.user_location_interactions set location_id = %L where user_id = %L',
        missing_id, fixture_user
    ), '23503');
    perform pg_temp.expect_error(format(
        'update public.trips set user_id = null where id = %L', fixture_trip
    ), '23502');
    perform pg_temp.expect_error(format(
        'insert into public.users (name, email) values (%L, %L)', 'Duplicate', fixture_email
    ), '23505');
    perform pg_temp.expect_error(format(
        'insert into public.itinerary_items (trip_id, location_id, day_number, visit_order)
         values (%L, %L, 1, 1)', fixture_trip, fixture_location
    ), '23505');

    -- Invalid money, dates, coordinates, and scheduling metadata.
    perform pg_temp.expect_error(format(
        'update public.users set default_budget_min = -1 where id = %L', fixture_user
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.users set default_budget_min = 20, default_budget_max = 10 where id = %L',
        fixture_user
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.users set default_budget_max = %L where id = %L', 'NaN', fixture_user
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.trips set budget_min = -1 where id = %L', fixture_trip
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.trips set budget_max = -1 where id = %L', fixture_trip
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.trips set budget_min = 600 where id = %L', fixture_trip
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.trips set budget_max = %L where id = %L', 'NaN', fixture_trip
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.trips set estimated_total_cost = -1 where id = %L', fixture_trip
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.trips set end_date = %L where id = %L', '2026-10-18', fixture_trip
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.trips set title = %L where id = %L', '   ', fixture_trip
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.locations set latitude = 91 where id = %L', fixture_location
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.locations set longitude = 181 where id = %L', fixture_location
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.locations set latitude = null where id = %L', fixture_location
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.locations set opening_hours = %L::jsonb where id = %L',
        '[]', fixture_location
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.locations set estimated_cost_min = -1 where id = %L', fixture_location
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.locations set estimated_cost_min = 100, estimated_cost_max = 50 where id = %L',
        fixture_location
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.locations set typical_visit_duration = 0 where id = %L', fixture_location
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.itinerary_items set day_number = 0 where id = %L', fixture_item
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.itinerary_items set visit_order = 0 where id = %L', fixture_item
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.itinerary_items set estimated_travel_time = -1 where id = %L', fixture_item
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.itinerary_items set estimated_cost = -1 where id = %L', fixture_item
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.itinerary_items set recommendation_score = %L where id = %L',
        'Infinity', fixture_item
    ), '23514');

    -- Ratings belong only to rating events; negative left-swipe weights are valid.
    perform pg_temp.expect_error(format(
        'update public.user_location_interactions set interaction_type = %L where user_id = %L',
        'unsupported', fixture_user
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.user_location_interactions set rating_value = null
         where user_id = %L and interaction_type = %L', fixture_user, 'rating'
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.user_location_interactions set rating_value = 5
         where user_id = %L and interaction_type = %L', fixture_user, 'save'
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.user_location_interactions set interaction_value = %L where user_id = %L',
        'NaN', fixture_user
    ), '23514');
    perform pg_temp.expect_error(format(
        'update public.user_location_interactions set rating_value = %L
         where user_id = %L and interaction_type = %L', 'Infinity', fixture_user, 'rating'
    ), '23514');

    -- Retiring a destination preserves history; deleting a referenced one is rejected.
    update public.locations set is_active = false where id = fixture_location;
    if not exists (select 1 from public.itinerary_items where id = fixture_item) then
        raise exception 'Deactivating a destination removed an itinerary item';
    end if;
    perform pg_temp.expect_error(format(
        'delete from public.locations where id = %L', fixture_location
    ), '23503');
    delete from public.trips where id = fixture_trip;
    if exists (select 1 from public.itinerary_items where trip_id = fixture_trip) then
        raise exception 'Deleting a trip did not cascade to its itinerary';
    end if;
    if not exists (select 1 from public.locations where id = fixture_location)
        or not exists (
            select 1 from public.user_location_interactions where user_id = fixture_user
        ) then
        raise exception 'Deleting a trip removed unrelated data';
    end if;

    insert into public.trips (user_id, title, start_date, end_date, budget_min, budget_max)
    values (fixture_user, 'Second Trip', '2026-10-19', '2026-10-19', 0, 0)
    returning id into fixture_trip;
    insert into public.itinerary_items (trip_id, location_id, day_number, visit_order)
    values (fixture_trip, fixture_location, 1, 1);
    delete from public.users where id = fixture_user;
    if exists (select 1 from public.trips where user_id = fixture_user)
        or exists (select 1 from public.itinerary_items where trip_id = fixture_trip)
        or exists (select 1 from public.user_location_interactions where user_id = fixture_user) then
        raise exception 'User deletion did not cascade through owned records';
    end if;
    delete from public.locations where id = fixture_location;

    -- Inspect all five tables for RLS and operation-specific role grants.
    foreach table_name in array array[
        'users', 'locations', 'user_location_interactions', 'trips', 'itinerary_items'
    ] loop
        if not exists (
            select 1 from pg_class c join pg_namespace n on n.oid = c.relnamespace
            where n.nspname = 'public' and c.relname = table_name and c.relrowsecurity
        ) then
            raise exception 'RLS is missing for %', table_name;
        end if;
        foreach operation in array array['SELECT', 'INSERT', 'UPDATE', 'DELETE'] loop
            foreach client_role in array array['anon', 'authenticated'] loop
                if has_table_privilege(client_role, 'public.' || table_name, operation) then
                    raise exception '% unexpectedly has % on %', client_role, operation, table_name;
                end if;
            end loop;
            if not has_table_privilege('service_role', 'public.' || table_name, operation) then
                raise exception 'Server role lacks % on %', operation, table_name;
            end if;
        end loop;
    end loop;
    raise notice 'CRUD, defaults, joins, constraints, cascades, and access metadata passed';
end;
$test$;

-- Exercise client denials under the actual roles, not just metadata checks.
set local role anon;
do $test$
begin
    begin
        perform 1 from public.users limit 1;
        raise exception 'anon unexpectedly read users';
    exception when insufficient_privilege then
        null;
    end;
    begin
        insert into public.users (name, email) values ('Denied', 'anon@example.invalid');
        raise exception 'anon unexpectedly inserted a user';
    exception when insufficient_privilege then
        null;
    end;
end;
$test$;
reset role;

set local role authenticated;
do $test$
begin
    begin
        perform 1 from public.trips limit 1;
        raise exception 'authenticated unexpectedly read trips';
    exception when insufficient_privilege then
        null;
    end;
    begin
        delete from public.trips;
        raise exception 'authenticated unexpectedly deleted trips';
    exception when insufficient_privilege then
        null;
    end;
end;
$test$;
reset role;

set local role service_role;
do $test$
declare
    fixture_user uuid;
begin
    insert into public.users (name, email)
    values ('Server Access Test', gen_random_uuid()::text || '@example.invalid')
    returning id into fixture_user;
    if not exists (select 1 from public.users where id = fixture_user) then
        raise exception 'Server role could not read its inserted user';
    end if;
    update public.users set name = 'Updated Server Test' where id = fixture_user;
    delete from public.users where id = fixture_user;
    raise notice 'Actual client-role denials and server-role CRUD passed';
end;
$test$;
reset role;

rollback;
