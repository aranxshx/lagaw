The DevOps Engineer is graded on one question: how well did you build, run, and improve the system that takes your team's code to production? You choose the tools: any CI/CD platform, any hosting provider, containers or not. What gets graded is the design, the automation, the measured improvement, and the evidence.
    - Pipeline design. Build a pipeline that checks every pull request and deploys every merge to main without manual steps.
- Environments. Keep at least a production environment, and ideally a staging or per-pull-request preview environment, each with its own configuration and secrets.
- Secrets. Make sure no secret ever enters the repository. Inject secrets from your CI platform or hosting provider's secret store, scoped per environment.
- Quality gates. Make the pipeline the gatekeeper: protected main branch, required checks, and required review before merge.
- Release and rollback. Know how to roll production back to the last good version, and prove you can do it.
- Measurement. Track how your pipeline performs every week and show the effect of every optimization with numbers.
- Developer experience. Fast, clear feedback is the point. A pipeline that takes 20 minutes and fails with unreadable logs is slowing your team down.
This is a reference, not a required template. Build what your project needs.
1. Install dependencies (cached)
2. Lint and format check
3. Type check, if your language supports it
4. Unit tests, with LLM calls mocked
5. Build (app bundle, container image, or both)
6. Integration tests against a test database
7. Security checks: dependency audit, secret scanning
8. Deploy to a preview or staging environment
9. Smoke tests against the deployed environment
10. Promote or deploy to production
11. Post-deploy health check and team notification
You are expected to make your pipeline measurably faster and more reliable over the four sprints. Common techniques include:
- Caching dependencies and build outputs between runs
- Running independent jobs in parallel instead of in sequence
- Ordering stages fail-fast, so cheap checks (lint) run before expensive ones (build, integration tests)
- Path filters, so a frontend-only change doesn't rerun backend tests and vice versa
- Cancelling outdated runs when a new commit is pushed to the same branch
- Container layer caching and smaller base images
- Splitting slow test suites across parallel runners
- Hunting down and fixing flaky tests instead of re-running until green
AI applications bring problems most textbook pipelines don't cover. Strong DevOps Engineers address them:
- Cost. Calling a paid LLM on every test run burns money and adds flakiness. Mock the provider in unit tests and reserve live calls for a small, scheduled smoke test.
- Prompt changes are code changes. When a prompt or AI logic changes, run the team's evaluation set automatically and report whether quality held.
- Non-determinism. Test the shape and validity of AI output (schema checks, required fields), not exact wording.
- Provider outages. Make sure a provider outage doesn't block deploys of unrelated changes.
- Key hygiene. Use separate AI API keys per environment where possible, with spending limits on the non-production keys.
Keep this log in your repository and update it before every consultation. These measures are adapted from the DORA metrics used by industry teams to gauge delivery performance.
Week
Avg PR pipeline time (min)
Main pipeline time (min)
Pipeline success rate (%)
Production deploys
Avg lead time, merge to live (min)
Failed deploys
Time to recover (min)
Change made this week
Sprint 1
Sprint 2
Sprint 3
Sprint 4
- The pipeline configuration files, in the repository
- A pipeline document (for example, PIPELINE.md) explaining each stage, why it exists, and its trigger conditions
- A pipeline diagram
- The completed metrics log
- An optimization log: each change, the before and after numbers, and what you learned
- A deploy and rollback runbook any teammate could follow
- An incident log: every broken build or failed deploy that reached main or production, with a short postmortem (what happened, root cause, fix, prevention)