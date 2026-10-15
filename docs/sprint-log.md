# Sprint Log

Running record of Lagaw's sprints: plans, standup notes, and retrospectives, required by the [course instructions](official-instructions.md). Scope, provider, and infrastructure changes are recorded here with their reasoning.

## Sprint 1 — Foundation and walking skeleton

Goal: a thin, deployed version of the whole stack, end to end, even if it does almost nothing.

### Standup and activity notes

- **October 13, 2026** — Supabase account, organization, and project created. Credentials handed to Andrew (backend/database).
- **October 14, 2026, 3:00 PM** — Team onboarding: taught the team the workflow — looking at issues, creating branches and commits, opening pull requests, merging, and closing issues.
- **October 14, 2026, 3:30 PM** — DeepSeek API key created (label `Kyle/Cygray`) on Kyle's personal DeepSeek platform account. Purpose: testing ahead of the first consultation without spending additional credits, since the personal account already has credits. Key sent to Jeff. The key itself is shared out of band and never committed to the repository.
- **October 14, 2026** — Provider decision recorded: structured extraction moved from Google Gemini to DeepSeek-V4.1-Flash via the official DeepSeek API (called from the backend with `httpx` against `https://api.deepseek.com`; the draft plan to use the OpenAI Python SDK was dropped when the integration landed). Model ID, configuration, and fallback behavior are documented in [the pitch](pitch.md).

- **October 14, 2026** — Hosting decision recorded: the Flutter Web build will be hosted on Cloudflare Pages, replacing the earlier "Cloudflare Pages or Netlify" option. Reasons: one provider to manage, free tier with automatic per-branch preview deployments that fit the pull request workflow, and a CLI-first workflow. Wrangler CLI is adopted as the DevOps management tool for Pages (project creation, deploys, deployment history), run locally and from the CI/CD pipeline with a token scoped to Cloudflare Pages. Backend hosting (Render or Railway) is unchanged and still undecided. Updated [the pitch](pitch.md), [README](../README.md), and [tooling setup](tooling.md) to match.

- **October 15, 2026** — CORS preparation: the developer reported no browser error yet. Confirmed the required Flutter → FastAPI → Supabase request path and prepared configurable FastAPI CORS middleware, offline policy checks, and a [local/deployment guide](cors.md). Updated `.env.example` with `CORS_ALLOWED_ORIGINS`; no real credentials were exposed or changed. All 27 offline backend tests (including nine CORS tests), Ruff lint, and the diff whitespace check passed locally. Flutter was unavailable on this session's PATH, so browser verification was not run. This session could not create `feat/backend-cors` because `.git` writes are blocked, so the changes remain uncommitted for the developer to move onto that branch. Live browser verification, PR review/CI, and deployment remain pending.

- **October 15, 2026** — Local CORS preflights verified by the developer against the running FastAPI server using `curl.exe`: `OPTIONS /locations` with origin `http://localhost:3000` returned HTTP 200 and `access-control-allow-origin: http://localhost:3000`; the same request with origin `https://unapproved.example` returned HTTP 400 with `Disallowed CORS origin` and no allow-origin header. Confirmed the checkout is now on `feat/backend-cors`. Flutter installation is deferred for these backend checks. Actual GET response verification, browser testing, PR review/CI, and deployment remain pending; these preflights do not verify database connectivity.

- **October 15, 2026** — Local CORS data-response check verified by the developer: `GET /locations?limit=1` with origin `http://localhost:3000` returned HTTP 200, `access-control-allow-origin: http://localhost:3000`, `vary: Origin`, and one database-backed location (Arima Restaurant) under `items`, with `limit=1` and `offset=0`. Together with the successful allowed/rejected preflight checks, this verifies the local backend's configured CORS behavior and database read. Browser testing, PR review/CI, and deployment verification remain pending.

### Open follow-ups

- Set the exact production/approved preview frontend origins in `CORS_ALLOWED_ORIGINS` on the backend host and verify them in a browser.
- Add the real HTTPS backend `API_BASE_URL` as a Dart define to the Flutter Web build used for deployment. The current CI build omits it and would retain the local `127.0.0.1:8000` default.

- Create the Cloudflare account and the `lagaw` Pages project, then create a scoped API token. Record who holds it (never the value) and add `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` to the CI secret store.
- Add `wrangler` as a dev dependency and wire `wrangler pages deploy` into the pipeline so merges to `main` deploy to production without manual steps (Sprint 1 requires a first pipeline-triggered deployment to a live URL).
- Write the deploy and rollback runbook with the Wrangler commands.
- Backend test call to DeepSeek to confirm the key and connectivity (Sprint 1 requirement).
- Wire the Supabase credentials shared with Andrew into the backend configuration.

### Sprint plan

Pending: fill in at sprint planning from the pitch backlog, with owners.

### Retrospective

Pending: first consultation.
