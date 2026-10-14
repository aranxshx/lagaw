# Sprint Log

Running record of Lagaw's sprints: plans, standup notes, and retrospectives, required by the [course instructions](official-instructions.md). Scope, provider, and infrastructure changes are recorded here with their reasoning.

## Sprint 1 — Foundation and walking skeleton

Goal: a thin, deployed version of the whole stack, end to end, even if it does almost nothing.

### Standup and activity notes

- **October 13, 2026** — Supabase account, organization, and project created. Credentials handed to Andrew (backend/database).
- **October 14, 2026, 3:00 PM** — Team onboarding: taught the team the workflow — looking at issues, creating branches and commits, opening pull requests, merging, and closing issues.
- **October 14, 2026, 3:30 PM** — DeepSeek API key created (label `Kyle/Cygray`) on Kyle's personal DeepSeek platform account. Purpose: testing ahead of the first consultation without spending additional credits, since the personal account already has credits. Key sent to Jeff. The key itself is shared out of band and never committed to the repository.
- **October 14, 2026** — Provider decision recorded: structured extraction moved from Google Gemini to DeepSeek-V4.1-Flash via the official DeepSeek API (OpenAI Python SDK, base URL `https://api.deepseek.com`). Model ID, configuration, and fallback behavior are documented in [the pitch](pitch.md).

- **October 14, 2026** — Hosting decision recorded: the Flutter Web build will be hosted on Cloudflare Pages, replacing the earlier "Cloudflare Pages or Netlify" option. Reasons: one provider to manage, free tier with automatic per-branch preview deployments that fit the pull request workflow, and a CLI-first workflow. Wrangler CLI is adopted as the DevOps management tool for Pages (project creation, deploys, deployment history), run locally and from the CI/CD pipeline with a token scoped to Cloudflare Pages. Backend hosting (Render or Railway) is unchanged and still undecided. Updated [the pitch](pitch.md), [README](../README.md), and [tooling setup](tooling.md) to match.

### Open follow-ups

- Create the Cloudflare account and the `lagaw` Pages project, then create a scoped API token. Record who holds it (never the value) and add `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` to the CI secret store.
- Add `wrangler` as a dev dependency and wire `wrangler pages deploy` into the pipeline so merges to `main` deploy to production without manual steps (Sprint 1 requires a first pipeline-triggered deployment to a live URL).
- Write the deploy and rollback runbook with the Wrangler commands.
- Backend test call to DeepSeek to confirm the key and connectivity (Sprint 1 requirement).
- Wire the Supabase credentials shared with Andrew into the backend configuration.

### Sprint plan

Pending: fill in at sprint planning from the pitch backlog, with owners.

### Retrospective

Pending: first consultation.
