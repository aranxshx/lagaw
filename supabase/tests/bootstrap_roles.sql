-- Only for a fresh, disposable vanilla PostgreSQL test database.
-- Supabase already supplies these roles; never run this on a hosted project.
create role anon nologin;
create role authenticated nologin;
create role service_role nologin bypassrls;
grant usage on schema public to anon, authenticated, service_role;
