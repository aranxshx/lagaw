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
- **October 14, 2026** — Branch `chore/cloudflare-pages-setup` opened (stacked on `docs/cloudflare-pages`) to set up the Cloudflare Pages CI/CD. Merge is deferred: it will be merged later, after `docs/cloudflare-pages` lands and the Cloudflare account, Pages project, and scoped token exist.
- **October 14, 2026** — Cloudflare Pages project `lagaw` created with Wrangler (`--production-branch main`; production URL `https://lagaw.pages.dev`) on Kyle's Cloudflare account. Wrangler 4.151 delegates new Pages projects to Workers and failed, so the project was created once with `--force` (classic Pages), as Wrangler's own error advised; later commands need no flag. Added `package.json` pinning `wrangler@4.151.0` and a first-draft deploy job (reworked in the next entry). Setting the repository secrets is pending: Kyle has push but not admin access on `aranxshx/lagaw`, so the repo owner must add `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` under Settings → Secrets and variables → Actions.
- **October 14, 2026** — Deploy pipeline finalized. A first draft put the deploy in its own `deploy-web.yml`, which rebuilt the web app on `main` even though `ci.yml` had just built it. Replaced with a single `deploy-web` job in `.github/workflows/ci.yml` that reuses the `frontend` job's build artifact, so each run builds once. `main` deploys to production and same-repo pull requests deploy a preview (fork PRs skipped). The job deploys only when the frontend (excluding `frontend/test/`) or deploy config changed, so docs-only and test-only merges do not deploy, decided by changed files rather than branch names (a branch-name rule was dropped as fragile). It skips cleanly while there is no Flutter web project or the Cloudflare secrets are unset. Also fixed a bug in the draft where a failed `wrangler` deploy piped into `tee` would still report success (added `set -eo pipefail`). Tested the gate script locally across 12 scenarios (app, test-only, docs-only, config, mixed, PR ranges, zero/bad base commit, manual run, missing secrets, missing web platform) and ran the exact `wrangler pages deploy` command against a placeholder on the preview branch `deploy-check` (preview deployment `04d92b05` is a leftover test artifact). The full run on GitHub is untested until the change is merged, `frontend/` exists, and the secrets are set. Not yet adopted: see [CI/CD best practices](cicd-best-practices.md).

### Open follow-ups

- Create a Cloudflare API token scoped to Pages edit, record who holds it (never the value), and have the repo owner add `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` as GitHub Actions secrets. Done already: Cloudflare account, `lagaw` Pages project, `wrangler` dev dependency, and the `deploy-web` job in `ci.yml`.
- Once `frontend/` (Flutter) lands on `main`, confirm the first pipeline-triggered production deployment at `https://lagaw.pages.dev` (Sprint 1 requirement).
- Write the deploy and rollback runbook with the Wrangler commands.
- Backend test call to DeepSeek to confirm the key and connectivity (Sprint 1 requirement).
- Wire the Supabase credentials shared with Andrew into the backend configuration.

### Sprint plan

Pending: fill in at sprint planning from the pitch backlog, with owners.

### Retrospective

Pending: first consultation.
