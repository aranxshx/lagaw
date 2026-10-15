# Flutter Web to FastAPI: CORS setup

The [pitch](pitch.md) and [course requirements](official-instructions.md#3-what-your-finished-product-must-do)
require this request path:

```text
Flutter Web / Android -> FastAPI -> Supabase PostgreSQL
```

Flutter must call FastAPI, which owns the database and AI logic. Keep Supabase
backend credentials and DeepSeek keys on the backend. CORS belongs on FastAPI
because that is the server the browser calls.

An origin is a scheme, host, and port. For example, `http://localhost:3000`
and `http://127.0.0.1:8000` are different origins. A browser needs permission
from the API to let the first page read a response from the second server.
FastAPI's `CORSMiddleware` supplies that permission for configured origins and
answers CORS preflight (`OPTIONS`) requests. See
[FastAPI's CORS documentation](https://fastapi.tiangolo.com/tutorial/cors/).

There is no reported browser failure yet. This change prepares cross-origin
access for local development and deployment; it does not diagnose a live outage.

## What the implementation does

`backend/app/main.py` reads `CORS_ALLOWED_ORIGINS` once when the application is
created. It loads the repository-root `.env` with `override=False`, so hosting
environment variables take priority. Restart the backend after changing CORS
configuration, including `.env` edits.

- Origins are an explicit comma-separated list. Whitespace around entries and
  empty entries are ignored. Wildcards, credentials in URLs, paths, query
  strings, and fragments cause a configuration error at startup. The error names
  the setting without echoing its value.
- Missing or empty configuration grants no cross-origin browser permission.
- Allowed methods are `GET`, `POST`, `PUT`, `PATCH`, and `DELETE`. The middleware
  answers preflight `OPTIONS` automatically; no extra endpoint is needed. This
  policy does not create CRUD endpoints: `/locations` still supports only GET.
- `Content-Type` and `Authorization` request headers are allowed. Cookie
  credentials remain disabled because the current API does not use cookies.
  Revisit this with the teammate implementing authentication if cookie sessions
  are chosen. Allowing an Authorization header does not implement authentication.
- Handled failures, including validation errors and database-unavailable 503
  responses, carry CORS headers for approved origins. Unexpected unhandled 500
  errors still need server-side diagnosis and may lack these headers with the
  standard FastAPI middleware ordering.

CORS controls what a browser page can read. It is not authentication or database
access control. An unapproved simple request can still reach the backend, and
Android and command-line clients do not enforce browser CORS rules. Keep backend
authorization and Supabase access controls in place.

## 1. Work in a feature branch

From a PowerShell terminal at the repository root:

```powershell
git switch -c feat/backend-cors
```

If the branch already exists, use `git switch feat/backend-cors`. The local CORS
files were prepared without a commit; creating the branch carries those edits
onto it. This session cannot write `.git`, so branch creation must be run in your
own terminal. Every change must go through a reviewed PR, as required by
[AGENTS.md](../AGENTS.md) and the README branch strategy.

## 2. Configure and start the backend locally

Add this line to your existing private root `.env`, preserving its other values:

```dotenv
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
```

These addresses are the **frontend** origins. Do not put the Supabase URL or the
API URL in this list. Do not add a trailing slash. `localhost` and `127.0.0.1`
are distinct browser hosts, so both are explicitly listed for local use.

Use the existing environment and dependencies from the
[locations API guide](locations-api.md), then run:

```powershell
.\.venv\Scripts\python.exe -m uvicorn app.main:app --app-dir backend --reload
```

The `/locations` endpoint also needs the matching backend Supabase URL and key
described in that guide. CORS preflight itself does not query Supabase.

## 3. Run Flutter Web with a fixed frontend port

In a second terminal, from the repository root:

```powershell
Set-Location frontend
flutter pub get
flutter run -d chrome --web-port 3000 --dart-define=API_BASE_URL=http://127.0.0.1:8000
```

`frontend/lib/config.dart` already reads `API_BASE_URL` at build time. This is
the **backend** address; Flutter does not read it from the root `.env`.
Keep the frontend port fixed so it matches the CORS list. If you use a different
port, update the list and restart FastAPI.

## 4. Verify CORS and the actual data request

In another PowerShell terminal, check an allowed preflight:

```powershell
curl.exe -i -X OPTIONS "http://127.0.0.1:8000/locations" -H "Origin: http://localhost:3000" -H "Access-Control-Request-Method: GET" -H "Access-Control-Request-Headers: authorization,content-type"
```

Expect HTTP 200 and `access-control-allow-origin: http://localhost:3000`.
Repeat with `Origin: https://unapproved.example`; expect HTTP 400 with no
`access-control-allow-origin` header. A preflight success verifies the browser
policy, not database connectivity.

Open the running Flutter app. In browser developer tools, open **Network**,
reload, and select the `/locations` request. Expect HTTP 200, the seeded records
under `items`, and `access-control-allow-origin` matching the Flutter page's
origin. The request must go to FastAPI. A plain GET may not need a preflight,
so an absent OPTIONS request is normal. Seeing sample cards alone is not proof:
the frontend includes a sample-data option, so inspect the actual API response.

If HTTP 503 is visible, CORS has allowed you to read the error; troubleshoot the
backend database configuration using the locations guide. If there is no
response, check the backend address and whether the server is running.
Opening `/docs`, using curl, or testing Android alone does not prove browser
CORS access works.

Offline checks, using mock dependencies and no provider calls:

```powershell
.\.venv\Scripts\python.exe -m unittest discover -s backend -v
.\.venv\Scripts\python.exe -m ruff check backend
```

`backend/test_cors.py` is picked up by the existing backend CI job. It checks
approved/unapproved origins, preflights, headers, methods, handled errors,
requests without an Origin header, and missing/invalid configuration.

Local verification on October 15, 2026: all 27 backend tests, Ruff lint, and the
diff whitespace check passed. Flutter was unavailable on this session's PATH,
so no live browser or deployed-environment check was performed.

The developer subsequently verified the running local backend with `curl.exe`:
the approved-origin preflight returned 200 with the matching allow-origin header;
an unapproved-origin preflight returned 400 without that header; and
`GET /locations?limit=1` returned 200 with the approved origin's CORS header and
one database-backed location under `items`. These checks do not replace browser
and deployed-environment verification.

## 5. Configure deployment with the DevOps teammate

Once the real frontend and backend URLs exist:

1. Set `CORS_ALLOWED_ORIGINS` on the **backend host** to the actual HTTPS
   frontend origin, for example `https://YOUR_PROJECT.pages.dev`. Replace this
   placeholder with the assigned Pages address. Include any custom domain or
   explicitly approved preview origin as additional comma-separated entries.
   Do not permit all `*.pages.dev` sites. Restart/redeploy the backend.
2. Build Flutter Web with the real public HTTPS backend URL:
   `flutter build web --release --dart-define=API_BASE_URL=https://YOUR_BACKEND_HOST`.
   The current `.github/workflows/ci.yml` builds without this define, so the
   DevOps teammate must add it to the build job that supplies the deployed
   artifact. Otherwise the compiled frontend defaults to `127.0.0.1:8000`,
   which points at each visitor's own machine.
3. Deploy that build through the team's Cloudflare Pages pipeline. A page
   served over HTTPS must call an HTTPS API to avoid mixed-content blocking,
   which CORS does not fix. See
   [MDN's mixed-content guide](https://developer.mozilla.org/en-US/docs/Web/Security/Mixed_content).
4. Repeat the preflight and browser data checks against the deployed URLs.
   Preview deployments on a shared backend also need their exact origin
   explicitly approved; add/remove those entries with the DevOps teammate.

Do not put database passwords, Supabase backend keys, or DeepSeek credentials
in `--dart-define`; those values become part of the frontend build. Backend
settings and credentials belong in that environment's configuration.

## 6. Submit the work through a PR

When the issue is created, link it to this work. Suggested title:
**Configure FastAPI CORS for Flutter Web**.

Review the diff and commit only the task files:

```powershell
git diff
git add backend/app/main.py backend/test_cors.py .env.example docs/cors.md docs/locations-api.md docs/sprint-log.md README.md
git commit -m "feat: configure CORS for Flutter Web"
git push -u origin feat/backend-cors
```

Open a PR targeting `main`, include test results and any browser verification,
and request a teammate's review. Wait for CI and review before merging.
Per the course's Definition of Done, this issue remains pending until the change
is merged, deployed through the pipeline, and verified in the deployed browser
app. Record only completed checks in the PR and sprint log.
