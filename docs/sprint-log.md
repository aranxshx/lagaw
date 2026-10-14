# Sprint Log

Running record of Lagaw's sprints: plans, standup notes, and retrospectives, required by the [course instructions](official-instructions.md). Scope, provider, and infrastructure changes are recorded here with their reasoning.

## Sprint 1 — Foundation and walking skeleton

Goal: a thin, deployed version of the whole stack, end to end, even if it does almost nothing.

### Standup and activity notes

- **October 13, 2026** — Supabase account, organization, and project created. Credentials handed to Andrew (backend/database).
- **October 14, 2026, 3:00 PM** — Team onboarding: taught the team the workflow — looking at issues, creating branches and commits, opening pull requests, merging, and closing issues.
- **October 14, 2026, 3:30 PM** — DeepSeek API key created (label `Kyle/Cygray`) on Kyle's personal DeepSeek platform account. Purpose: testing ahead of the first consultation without spending additional credits, since the personal account already has credits. Key sent to Jeff. The key itself is shared out of band and never committed to the repository.
- **October 14, 2026** — Provider decision recorded: structured extraction moved from Google Gemini to DeepSeek-V4.1-Flash via the official DeepSeek API (OpenAI Python SDK, base URL `https://api.deepseek.com`). Model ID, configuration, and fallback behavior are documented in [the pitch](pitch.md).

### Open follow-ups

- Backend test call to DeepSeek to confirm the key and connectivity (Sprint 1 requirement).
- Wire the Supabase credentials shared with Andrew into the backend configuration.

### Sprint plan

Pending: fill in at sprint planning from the pitch backlog, with owners.

### Retrospective

Pending: first consultation.
