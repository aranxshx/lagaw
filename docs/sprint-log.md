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
- **October 14, 2026** — Cloudflare Pages project `lagaw` created with Wrangler (`--production-branch main`; production URL `https://lagaw.pages.dev`) on Kyle's Cloudflare account. Wrangler 4.151 delegates new Pages projects to Workers and failed, so the project was created once with `--force` (classic Pages), as Wrangler's own error advised; later commands need no flag. Added `package.json` pinning `wrangler@4.151.0` and a first-draft deploy job (reworked in the next entry). Setting the repository secrets was initially blocked because the repository was a personal account repo where Kyle had push but not admin access; see the next entries.
- **October 14, 2026** — Deploy pipeline finalized. A first draft put the deploy in its own `deploy-web.yml`, which rebuilt the web app on `main` even though `ci.yml` had just built it. Replaced with a single `deploy-web` job in `.github/workflows/ci.yml` that reuses the `frontend` job's build artifact, so each run builds once. `main` deploys to production and same-repo pull requests deploy a preview (fork PRs skipped). The job deploys only when the frontend (excluding `frontend/test/`) or deploy config changed, so docs-only and test-only merges do not deploy, decided by changed files rather than branch names (a branch-name rule was dropped as fragile). It skips cleanly while there is no Flutter web project or the Cloudflare secrets are unset. Also fixed a bug in the draft where a failed `wrangler` deploy piped into `tee` would still report success (added `set -eo pipefail`). Tested the gate script locally across 12 scenarios (app, test-only, docs-only, config, mixed, PR ranges, zero/bad base commit, manual run, missing secrets, missing web platform) and ran the exact `wrangler pages deploy` command against a placeholder on the preview branch `deploy-check` (preview deployment `04d92b05` is a leftover test artifact). The full run on GitHub is untested until the change is merged, `frontend/` exists, and the secrets are set. Not yet adopted: see [CI/CD best practices](cicd-best-practices.md).
- **October 15, 2026** — Repository ownership transferred from the personal account `aranxshx` to the GitHub organization `relax-mode` (now `relax-mode/lagaw`), so the DevOps Engineer has admin access. Reason: personal-account repositories cannot grant collaborators admin rights, and the DevOps role needs to manage secrets, environments, and branch protection. The old URL redirects; the local `origin` remote was updated. No `aranxshx` references remain in tracked files.
- **October 15, 2026** — Cloudflare deploy secrets added: Kyle created an account-scoped API token (Cloudflare Pages edit) and kept it in his local, gitignored `.env.local`; it and the account ID were then set as `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` GitHub Actions secrets on `relax-mode/lagaw`. The token was verified as active and able to reach the `lagaw` Pages project before use. Values never appear in the repository, this log, or command output. A re-run of pull request #18's earlier workflow run correctly skipped the deploy job (a re-run reuses the original event payload, whose head repository name predates the transfer), so the real end-to-end check is the run triggered by the next push.

### Open follow-ups

- Confirm the first pipeline-triggered Cloudflare Pages deployment from pull request #18 (preview) and then from `main` (production). Cloudflare account, `lagaw` Pages project, `wrangler` dev dependency, the `deploy-web` job, and the GitHub Actions secrets are all in place.
- Write the deploy and rollback runbook with the Wrangler commands.
- Backend test call to DeepSeek to confirm the key and connectivity (Sprint 1 requirement).
- Wire the Supabase credentials shared with Andrew into the backend configuration.

### Sprint plan

Pending: fill in at sprint planning from the pitch backlog, with owners.

### Retrospective

Pending: first consultation.
