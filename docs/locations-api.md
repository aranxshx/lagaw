# Sample locations and FastAPI (S1-02)

The seed is `supabase/migrations/20261014154651_seed_sample_locations.sql`.
It inserts the ten researched locations with stable UUIDs; rerunning its insert
does not duplicate those IDs or overwrite existing records. The source JSON is
`supabase/data/locations.json`; factual sources, estimates, and unknowns are
documented in [location-data-sources.md](location-data-sources.md).
The seed changes only locations. It does not create users, interactions, trips,
or itinerary items. Keep the already-applied S1-01 schema migration unchanged.

## Configure the backend for the test database

Run these commands in **PowerShell from the repository root**, not the SQL Editor.
Create `.env` from `.env.example` if it does not already exist; preserve any
DeepSeek settings already in your `.env`. Set these values in that private file:

```dotenv
SUPABASE_URL=https://vnpkyvtbupnquvirzlzp.supabase.co
SUPABASE_SERVICE_ROLE_KEY=YOUR_TEST_PROJECT_BACKEND_KEY
```

Copy the test project's backend **secret key** (`sb_secret_...`) from Supabase
Settings → API Keys. An existing legacy `service_role` key also works. The
environment variable retains its original name for compatibility with the
project pitch. Do not use an anon/publishable key: the S1-01 migration deliberately
grants database access only to the backend role. Never paste real keys into chat,
GitHub, Flutter code, or documentation.

This endpoint needs only these two variables; it does not use `DATABASE_URL` or
call DeepSeek. Environment variables supplied by a hosting platform take priority
over `.env`. Supabase CLI linkage and MCP scope do **not** configure the API's
database: `SUPABASE_URL` and its matching key select the project at runtime.

If you have not applied the seed to the test project yet:

```powershell
Get-Content supabase/.temp/project-ref
npx supabase db push --dry-run
npx supabase db push
```

The ref must be `vnpkyvtbupnquvirzlzp`. Skip these pushes if the ten records already
appear in that project's locations table.

## Install, test, and start

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r backend/requirements.txt
.\.venv\Scripts\python.exe -m unittest discover -s backend -v
.\.venv\Scripts\python.exe -m uvicorn app.main:app --app-dir backend --reload
```

If `.venv` already exists, reuse it and start with the install command. Using the
interpreter directly avoids PowerShell script execution-policy issues.

While the server runs, open <http://127.0.0.1:8000/docs>. Expand `GET /locations`,
choose **Try it out**, use `limit=10` and `offset=0`, then **Execute**. Expect HTTP
200 and ten database records under `items` if all ten remain active.

You can also check in a **second PowerShell terminal**:

```powershell
$page = Invoke-RestMethod 'http://127.0.0.1:8000/locations?limit=10&offset=0'
$page.items.Count
$page.items | Select-Object id, name, category
Invoke-RestMethod 'http://127.0.0.1:8000/locations?limit=3&offset=3'
Invoke-RestMethod 'http://127.0.0.1:8000/locations?offset=100'
```

The first count should be 10. The second request returns the next three records;
the last returns an empty `items` array. Test `limit=0` in `/docs` to see a 422
validation response. Stop the server with Ctrl+C.

## Endpoint contract

`GET /locations?limit=10&offset=0` returns:

```json
{"items": [], "limit": 10, "offset": 0}
```

`items` contains location objects with UUID `id` and all fourteen dataset fields.
Only active rows are returned, ordered by name then UUID. `limit` defaults to 10
and accepts 1–100; `offset` defaults to 0 and accepts nonnegative integers. An
empty page returns 200. Invalid pagination returns 422. Failed configuration,
database requests, or invalid database output return 503 with a generic message.

Unknown prices/coordinates/images stay `null`, and unknown hours stay `{}`.
Prices and coordinates serialize as JSON numbers; prices are Philippine pesos.
An active record is eligible for the catalog, not a guarantee the venue is open
at the time of the request. This public read endpoint exposes only location data.
It does not expose keys, user data, or database write operations.

FastAPI calls Supabase's Data REST API with the existing `httpx` dependency.
This is a real PostgreSQL read through PostgREST; the application never reads the
seed JSON as a fallback. The client applies a 10-second HTTP timeout and does not
follow redirects. References: [Supabase Data REST API](https://supabase.com/docs/guides/api),
[PostgREST filtering](https://docs.postgrest.org/en/stable/references/api/tables_views.html),
and [Supabase API keys](https://supabase.com/docs/guides/api/api-keys).

## Verification and review

Verification recorded on 2026-10-15: all 18 backend unittest checks passed
locally. The developer also confirmed the live test-project `/locations` response
contained all ten seeded destinations with `limit=10` and `offset=0`.
Ruff lint also passed from both the repository root and the backend directory.
PR CI and teammate review still need to complete before merge.

`backend/test_locations.py` checks the endpoint with a mocked HTTP transport,
including pagination, empty results, invalid input, database failures, invalid
responses, and secret handling. These offline tests require no real credentials
and run in the existing backend CI job with the DeepSeek tests. Offline tests
must be complemented by the live test against the seeded test project above.

After the live test passes, commit the S1-02 changes on `feat/sample-locations-api`,
push, and open a PR for teammate review. Record the offline test results and the
live API response in the PR. Wait for CI and review before merging. After merge,
apply the new data migration to the team's main Supabase project and coordinate
backend deployment with the DevOps teammate. Hosting uses that environment's URL
and backend key, not the test project's credentials. Do not mark the issue done
based only on seeing seeded rows: verify the database-backed API too.
