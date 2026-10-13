# Endterm Final Project Instructions

**Official Website with Resources:** https://csp221a.vercel.app/

## 1. Overview

Your approved pitch now becomes a real product. For the rest of the term, your team will build, ship, and present the full-stack AI-integrated application you pitched, following the same cycle a professional software team uses: plan the work, build it in short sprints, review each other's code, deploy continuously, report progress to stakeholders, and demo the finished product.

Think of the course staff as your **client and engineering leadership**. Weekly consultations are your sprint reviews. The final presentation is Demo Day, where you show a working product to stakeholders and defend the decisions you made to get there.

**What makes this project different from a normal class project:**

- **You choose everything.** Your problem domain, framework, language, database, AI provider, hosting platform, CI/CD tool, and workflow are yours to decide. There is no approved list. What matters is that you can justify every choice.
- **Process is graded, not just the result.** A polished app built in the last three days scores lower than a steady, well-managed build with a visible history of planning, reviews, and deployments.
- **One team member is a dedicated DevOps Engineer.** Their grade is based on how well they design, automate, optimize, and manage the team's CI/CD workflow. Section 5 covers this role in detail.
- **You ship continuously.** From the first sprint, your app should live somewhere other than a laptop, and every merge to your main branch should move through an automated pipeline.

By the end, you should have a deployed product, a repository that tells the story of how it was built, and a presentation that proves you understand what you made.

## 2. Team Structure and Roles

Every team must have exactly **one DevOps Engineer**. Everyone else is a Developer, and how you divide development work is up to you. Declare your roles in your repository README and at your first consultation. Roles can change once mid-project if you have a good reason, but tell the instructor before the change and document it.

### **The DevOps Engineer (required)**

Owns the path from a developer's commit to a running production app. They design and maintain the CI/CD pipeline, manage environments and secrets, keep deployments healthy, and measure and improve how fast and reliably the team ships. They are not the team's backup coder. They may write application code, but their grade comes from the CI/CD rubric in Section 8.

### **Developers**

Own the product: frontend, backend API, database, and the AI feature. Many teams split this into areas such as the ones below, but you can organize it however works for you.

| Common role            | Typical ownership                                                                     |
| ---------------------- | ------------------------------------------------------------------------------------- |
| Backend / API Engineer | API design, routing, validation, database access, error handling                      |
| AI Engineer            | LLM integration, prompts, RAG or tool-calling logic, output validation, AI evaluation |
| Frontend Engineer      | UI, state management, wiring the frontend to the API, user-facing error states        |
| Full-stack Engineer    | A vertical slice of features end to end                                               |

### **Shared team responsibilities**

- **Product owner duty.** Pick one person, any role, to keep the backlog prioritized and speak for the product at consultations. This can rotate weekly.
- **Code review.** Every change to your main branch goes through a pull request reviewed by at least one other teammate.
- **Honest attribution.** Your commit history, pull requests, and issue assignments are how individual contribution is measured. Work that isn't visible in the repository is very hard to credit.

## 3. What Your Finished Product Must Do

The seven development requirements from your pitch are now the acceptance criteria for your final product. How you meet them is your call. The "what we'll look for" column tells you what gets checked at Demo Day.

| # | Requirement                              | What we'll look for                                                                                                           |
| - | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| 1 | CRUD on a real database                  | Create, read, update, and delete on your core resource, working live, persisting across refreshes and redeploys               |
| 2 | Non-trivial AI/LLM feature               | RAG, tool calling, structured extraction, or an agentic flow that does real work in the app, not a chatbot bolted on the side |
| 3 | Backend API (REST or GraphQL)            | The frontend never calls the LLM or database directly; the backend owns AI and data logic                                     |
| 4 | Functional frontend wired to the backend | Real data in the UI, with loading, empty, and error states handled                                                            |
| 5 | Relational database design               | 2+ related tables or collections with a working relationship used by the app                                                  |
| 6 | Environment and secrets management       | No secrets in the repository or its history; a complete .env.example; secrets injected per environment                        |
| 7 | Error handling for AI and requests       | Graceful behavior when the LLM times out, fails, or returns bad output, and when clients send malformed requests              |

### **The AI output rule still applies**

Your backend must do something with the AI's output before it reaches the frontend: validate it against a schema, transform it, store it, use it to trigger another step, or reject and retry it. Pure pass-through fails requirement 2.

### **Beyond the minimum**

The requirements are a floor, not a ceiling. Higher scores come from depth: an AI feature you have evaluated and can show measurably works, an API that handles edge cases cleanly, a database design that holds up to tricky questions. You are free to change your pitched scope as you learn. Just record the change and the reason in your sprint log.

## 4. The Development Lifecycle

The project runs as four one-week sprints followed by Demo Day. Each sprint ends with a consultation, which works as your sprint review. The sprint goals below describe a healthy pace. They are guidance, not gates: if your project needs a different order, go with it and explain why at consultation.

project roadmap · 4 sprints, 4 consultations, Demo Day

Each consultation closes a sprint; Demo Day presents the tagged release from production.

### **How a sprint works**

Each week, run the same loop a real team does:

1. **Sprint planning (start of week).** Pick the work for the week from your backlog. Break it into issues small enough to finish in a day or two. Assign an owner to each.
2. **Build in branches.** Each issue gets a branch. Work lands through a pull request that passes the pipeline and gets at least one teammate's review.
3. **Async standups (2 to 3 times a week).** In your team channel, each person posts what they finished, what's next, and what's blocking them. Keep these. They are evidence of your process.
4. **Continuous deployment.** Merged work deploys automatically. Your deployed app should always reflect your main branch.
5. **Sprint review (consultation).** Demo what's deployed, walk through your board, and present the pipeline report.
6. **Retrospective.** After consultation, write a short retro in your sprint log: what went well, what didn't, one thing you'll change next sprint.

### **Definition of Done**

A backlog item counts as done only when it is merged to main through a reviewed pull request, has passed the pipeline, is deployed, and has been checked in the deployed environment. "Works on my machine" is not done.

### **Sprint 1: Foundation and walking skeleton**

Goal: a thin, deployed version of the whole stack, end to end, even if it does almost nothing.

- Repository set up with a README, branch strategy, .gitignore, and .env.example
- Backlog created from your pitch, with issues for every requirement
- Database schema implemented and migrated
- A minimal frontend calling a minimal backend endpoint that reads from the database
- A first CI pipeline running on every pull request (at minimum: install, lint, build)
- First deployment to a live URL, triggered by the pipeline
- Make a single test call to your AI provider from the backend to confirm keys and connectivity

### **Sprint 2: Core resource and API**

Goal: full CRUD on your core resource, through a real API, visible in a real UI.

- All CRUD endpoints for your core resource with request validation
- The relationship between your tables working in actual features
- Frontend screens for creating, viewing, editing, and deleting records
- Automated tests for your API running in the pipeline
- Separate environments taking shape (for example, preview or staging alongside production)

### **Sprint 3: The AI feature**

Goal: your AI feature working end to end, with the backend processing its output.

- The AI feature integrated through the backend, with structured output, tool calling, retrieval, or multi-step logic in place
- Backend validation, transformation, or storage of AI output
- A small evaluation set: example inputs with expected outputs or acceptance checks, so you can tell when a prompt change makes things better or worse
- Mocked or stubbed LLM calls in automated tests, so the pipeline doesn't depend on a live, paid API for every run
- First pass at AI error handling: timeouts, provider errors, malformed output

### **Sprint 4: Hardening, polish, and release**

Goal: a product you'd be comfortable handing to a real user.

- Complete error handling across the app, for both AI failures and malformed requests
- UI polish: loading states, empty states, readable error messages
- Security review: no secrets in history, sensible input limits, rate limiting or cost guards on AI endpoints if relevant
- Pipeline optimization with before-and-after numbers
- Documentation finished: README, architecture diagram, API reference, setup guide
- A tagged release (for example, v1.0.0) with a changelog

### **Demo Day**

Code freeze happens before your presentation. The instructor will announce the exact cutoff. Your final presentation is delivered from the production deployment of your tagged release. Section 7 has the full format.

### **Deploy to the web for free**

By the Sprint 4 consultation, your production app must run on a public URL. Deploy from Sprint 1 so hosting problems surface early. Any free host works; these combine well (limits checked October 2026, confirm on each host's pricing page):

| Host                                                             | Use it for                     | Free tier                                                | Watch out for                                                                                                                         |
| ---------------------------------------------------------------- | ------------------------------ | -------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| [Vercel](https://vercel.com/pricing)   | Frontend and serverless routes | Hobby plan, deploys on every push                        | Personal, non-commercial use; caps can't be raised without upgrading                                                                  |
| [Render](https://render.com/docs/free) | Backend API                    | Free web services, 750 instance hours a month            | Sleeps after 15 idle minutes and takes about a minute to wake; free Postgres expires after 30 days, so don't use it for your database |
| [Railway](https://railway.com/pricing) | Backend plus services          | 30-day trial with $5 credit, then a small free allowance | Start the trial late enough that it covers Demo Day                                                                                   |
| [Neon](https://neon.com/pricing)       | Postgres database              | Permanent free plan, no credit card                      | Compute hours capped per project                                                                                                      |

Set secrets in each host's dashboard, never in the repository, and wake a sleeping backend a few minutes before consultations and Demo Day.

## 5. The DevOps Engineer Track

The DevOps Engineer is graded on one question: how well did you build, run, and improve the system that takes your team's code to production? You choose the tools: any CI/CD platform, any hosting provider, containers or not. What gets graded is the design, the automation, the measured improvement, and the evidence.

### **Your responsibilities**

- **Pipeline design.** Build a pipeline that checks every pull request and deploys every merge to main without manual steps.
- **Environments.** Keep at least a production environment, and ideally a staging or per-pull-request preview environment, each with its own configuration and secrets.
- **Secrets.** Make sure no secret ever enters the repository. Inject secrets from your CI platform or hosting provider's secret store, scoped per environment.
- **Quality gates.** Make the pipeline the gatekeeper: protected main branch, required checks, and required review before merge.
- **Release and rollback.** Know how to roll production back to the last good version, and prove you can do it.
- **Measurement.** Track how your pipeline performs every week and show the effect of every optimization with numbers.
- **Developer experience.** Fast, clear feedback is the point. A pipeline that takes 20 minutes and fails with unreadable logs is slowing your team down.

### **A mature pipeline usually covers these stages**

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

### **Optimization levers to explore**

You are expected to make your pipeline measurably faster and more reliable over the four sprints. Common techniques include:

- Caching dependencies and build outputs between runs
- Running independent jobs in parallel instead of in sequence
- Ordering stages fail-fast, so cheap checks (lint) run before expensive ones (build, integration tests)
- Path filters, so a frontend-only change doesn't rerun backend tests and vice versa
- Cancelling outdated runs when a new commit is pushed to the same branch
- Container layer caching and smaller base images
- Splitting slow test suites across parallel runners
- Hunting down and fixing flaky tests instead of re-running until green

### **AI-specific pipeline concerns**

AI applications bring problems most textbook pipelines don't cover. Strong DevOps Engineers address them:

- **Cost.** Calling a paid LLM on every test run burns money and adds flakiness. Mock the provider in unit tests and reserve live calls for a small, scheduled smoke test.
- **Prompt changes are code changes.** When a prompt or AI logic changes, run the team's evaluation set automatically and report whether quality held.
- **Non-determinism.** Test the shape and validity of AI output (schema checks, required fields), not exact wording.
- **Provider outages.** Make sure a provider outage doesn't block deploys of unrelated changes.
- **Key hygiene.** Use separate AI API keys per environment where possible, with spending limits on the non-production keys.

### **Weekly pipeline metrics log**

Keep this log in your repository and update it before every consultation. These measures are adapted from the DORA metrics used by industry teams to gauge delivery performance.

| Week     | Avg PR pipeline time (min) | Main pipeline time (min) | Pipeline success rate (%) | Production deploys | Avg lead time, merge to live (min) | Failed deploys | Time to recover (min) | Change made this week |
| -------- | -------------------------- | ------------------------ | ------------------------- | ------------------ | ---------------------------------- | -------------- | --------------------- | --------------------- |
| Sprint 1 |                            |                          |                           |                    |                                    |                |                       |                       |
| Sprint 2 |                            |                          |                           |                    |                                    |                |                       |                       |
| Sprint 3 |                            |                          |                           |                    |                                    |                |                       |                       |
| Sprint 4 |                            |                          |                           |                    |                                    |                |                       |                       |

### **What the DevOps Engineer submits**

- The pipeline configuration files, in the repository
- A pipeline document (for example, PIPELINE.md) explaining each stage, why it exists, and its trigger conditions
- A pipeline diagram
- The completed metrics log
- An optimization log: each change, the before and after numbers, and what you learned
- A deploy and rollback runbook any teammate could follow
- An incident log: every broken build or failed deploy that reached main or production, with a short postmortem (what happened, root cause, fix, prevention)

## 6. Weekly Consultations

Each sprint ends with a 15-minute consultation, scored out of 20 points. Treat it like a sprint review with a client: show working software, be honest about what slipped, and leave with clear next steps. The whole team attends, and every member should be able to speak to their own work.

### **Format (about 15 minutes)**

1. **Live demo, 4 minutes.** Show what you shipped this sprint, running from your deployed URL, not localhost.
2. **Board walkthrough, 3 minutes.** Open your project board. What was planned, what got done, what slipped and why.
3. **DevOps report, 3 minutes.** The DevOps Engineer presents the pipeline: what changed this week, the metrics log, any incidents and how they were handled.
4. **Risks and next sprint, 2 minutes.** Your biggest risk right now and what you'll deliver by the next consultation.
5. **Questions and feedback, 3 minutes.** The instructor may ask any team member to explain any part of the code.

### **Bring with you**

- The deployed app, open and ready
- Your project board, with this sprint's items visible
- The repository, with this sprint's pull requests
- The updated sprint log: plan, standup notes, and last sprint's retrospective
- The updated pipeline metrics log

### **Minimum expected at each consultation**

| Consultation | We expect to see at least                                                                                                           |
| ------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| Sprint 1     | Roles declared, backlog created, schema migrated, a walking skeleton deployed to a live URL, a CI pipeline running on pull requests |
| Sprint 2     | Full CRUD on the core resource through the API and UI, API tests in the pipeline, deploys on merge                                  |
| Sprint 3     | The AI feature working end to end with backend processing of its output, a small evaluation set, mocked LLM tests in CI             |
| Sprint 4     | Release candidate: error handling complete, documentation drafted, pipeline optimizations measured, rollback tested                 |

### **Consultation rubric (20 points per consultation)**

Each criterion is scored 0 to 4. A score of 0 means the item was missing or not shown.

| Criterion                   | 4: Exemplary                                                                                   | 3: Proficient                                          | 2: Developing                                            | 1: Beginning                               |
| --------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------ | -------------------------------------------------------- | ------------------------------------------ |
| Sprint delivery             | All committed items done, or slips explained with sound reasoning and re-planned               | Most committed items done; slips explained             | About half done; vague on what slipped                   | Little planned work done; no clear account |
| Working deployed increment  | New features demoed live on the deployed app, stable through the demo                          | Demo works on the deployed app with minor issues       | Demo partly deployed or shown on localhost               | No working demo, or screenshots only       |
| Engineering process         | Board is current; work flows through small, reviewed PRs; standups and retro logged            | Board mostly current; PRs reviewed; minor gaps in logs | Board stale or PRs merged without review; sparse logs    | No visible process; direct pushes to main  |
| Pipeline and DevOps report  | Pipeline improved this sprint with metrics to prove it; incidents logged with postmortems      | Pipeline running and maintained; metrics log updated   | Pipeline exists but is unreliable or metrics are missing | Pipeline mostly manual or broken           |
| Risk awareness and planning | Names the real top risk with a concrete mitigation; next sprint plan is specific and realistic | Identifies risks and gives a reasonable plan           | Generic risks or vague plan                              | No risk awareness or plan                  |

The instructor may also ask any member to explain code they wrote. If a member can't explain their own work, that member's share of the consultation score can be reduced.

## 7. Final Presentation (Demo Day)

Demo Day is a 30-minute session per team: 20 minutes of presentation and 10 minutes of panel questions, scored out of 100 points. You are presenting to stakeholders who will decide whether this product ships. Show them it works, show them how it works, and show them you can keep it running.

### **Suggested flow (20 minutes)**

You may structure your presentation however you like, but it must cover all of these.

| Segment             | Time  | What to cover                                                                                                  |
| ------------------- | ----- | -------------------------------------------------------------------------------------------------------------- |
| Problem and product | 3 min | Who it's for, the problem, why your solution is worth using                                                    |
| Architecture        | 4 min | A system diagram: frontend, API, database, AI provider, hosting, pipeline; key design decisions and trade-offs |
| Live demo           | 6 min | A real user journey on the production deployment, including full CRUD and the AI feature                       |
| AI deep dive        | 3 min | How the AI feature works, what the backend does with its output, how you evaluated it, how it fails gracefully |
| DevOps and delivery | 4 min | The DevOps Engineer walks through the pipeline, environments, metrics trend, optimizations, and incidents      |

### **The live deploy challenge**

At the start of your session, the panel will ask for a small, visible change, such as new wording on a page. A developer makes the change, opens a pull request, gets it reviewed, and merges it. The pipeline must carry it to production before your session ends, with the DevOps Engineer narrating each stage. A fast, reliable pipeline makes this easy. A slow or fragile one will show.

### **Panel questions (10 minutes)**

Expect questions directed at specific team members, not the team as a whole. You may also be asked to:

- Explain any part of the codebase, chosen by the panel
- Show what the app does when the AI provider fails or returns bad output (have a way to simulate this ready)
- Send a malformed request to your API and show the response
- Show that no secrets exist in your repository history
- Roll production back to the previous release

### **Final presentation rubric (100 points, team score)**

| Criterion                     | Pts | Excellent (90 to 100%)                                                                                         | Satisfactory (60 to 80%)                                             | Needs work (below 50%)                                               |
| ----------------------------- | --- | -------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Problem and product clarity   | 10  | Clear user, real problem, convincing value; scope decisions explained                                          | Problem and user clear; value somewhat generic                       | Unclear who it's for or why it matters                               |
| Live demo, CRUD, and data     | 15  | Full CRUD on production, related data used meaningfully, no crashes                                            | CRUD works with minor glitches                                       | Partial CRUD, local-only demo, or frequent failures                  |
| AI feature depth              | 20  | Non-trivial AI that does real work; backend validates, transforms, or acts on output; evaluation results shown | AI feature works and output is processed, but shallow or unevaluated | AI is pass-through, a bolt-on chatbot, or doesn't work               |
| Architecture and API design   | 10  | Clean separation of concerns; sensible API design; trade-offs explained with confidence                        | Reasonable structure with some coupling or inconsistency             | Frontend reaches the LLM or database directly; design not understood |
| Error handling and resilience | 10  | AI failures and malformed requests handled gracefully in a live drill, with clear user-facing messages         | Most failures handled; some rough edges                              | Crashes, raw stack traces, or silent failures                        |
| Security and secrets          | 5   | No secrets in history; .env.example complete; per-environment secrets; input and cost guards                   | Secrets handled correctly with minor gaps                            | Secrets committed or hard-coded                                      |
| Engineering process           | 10  | Repository shows steady sprints, small reviewed PRs, maintained board, logs, and retros                        | Process visible but uneven, with some bursty or unreviewed work      | Little history; most work dumped near the deadline                   |
| Live deploy challenge         | 5   | Change reaches production through the full pipeline within the session                                         | Deploys with a manual workaround or after the session                | Change not deployed                                                  |
| Delivery and Q&A              | 15  | Every member answers questions on their own work with depth; presentation is well paced                        | Most questions answered; some gaps                                   | Members can't explain their own work                                 |

The DevOps segment and live deploy challenge also feed into the DevOps Engineer's individual CI/CD grade in Section 8.

## 8. Individual Track Rubrics

Each student also gets an individual score out of 100. Developers are scored on the Developer Contribution rubric. The DevOps Engineer is scored on the CI/CD Workflow rubric instead. Evidence comes from the repository, the project board, sprint logs, consultations, and Demo Day.

### **Developer Contribution rubric (100 points)**

| Criterion               | Pts | Excellent (90 to 100%)                                                                          | Satisfactory (60 to 80%)                                                | Needs work (below 50%)                    |
| ----------------------- | --- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- | ----------------------------------------- |
| Ownership and scope     | 25  | Owned a substantial, clearly identifiable part of the product end to end                        | Meaningful contribution, but narrower or shared without clear ownership | Minor or unclear contribution             |
| Code quality            | 20  | Readable, consistent, tested code that follows team conventions and passes the pipeline cleanly | Working code with some gaps in tests or consistency                     | Untested, fragile, or hard-to-follow code |
| Consistency over time   | 15  | Steady commits and PRs in every sprint                                                          | Contributions in most sprints, some bursts                              | Most work landed in the final days        |
| Collaboration           | 15  | Thoughtful PR reviews of teammates' work; active in standups; unblocks others                   | Reviews and standups done, but light                                    | Rarely reviews or communicates            |
| Technical understanding | 25  | Explains own code and design decisions with depth, and can reason about alternatives            | Explains own code with some gaps                                        | Can't explain own code                    |

### **CI/CD Workflow rubric for the DevOps Engineer (100 points)**

| Criterion                             | Pts | Excellent (90 to 100%)                                                                                                                      | Satisfactory (60 to 80%)                                              | Needs work (below 50%)                                  |
| ------------------------------------- | --- | ------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- | ------------------------------------------------------- |
| Pipeline design and coverage          | 15  | Well-ordered stages covering lint, tests, build, security checks, deploy, and post-deploy verification; each stage justified in PIPELINE.md | Core stages present (lint, test, build, deploy) with reasonable order | Pipeline only builds or deploys, with few checks        |
| Automation and quality gates          | 10  | Zero manual deploy steps; protected main; required checks and reviews enforced                                                              | Mostly automated; gates exist but are loosely enforced                | Manual deploys or unprotected main                      |
| Optimization with measured results    | 20  | Multiple optimizations, each with before-and-after numbers; clear downward trend in pipeline time and failure rate                          | Some optimizations with partial evidence                              | No optimization, or claims without numbers              |
| Environments and secrets              | 10  | Separate environments (production plus staging or previews) with scoped secrets; nothing sensitive in history                               | Production plus local, secrets handled correctly                      | Single environment with secrets mishandled              |
| AI-aware pipeline practices           | 10  | LLM mocked in tests; evaluation set runs on prompt or AI changes; scheduled live smoke test; cost-guarded keys                              | Mocked tests and some AI-specific checks                              | Live, unguarded AI calls on every run, or no AI testing |
| Release and rollback                  | 10  | Tagged releases with changelog; rollback runbook tested and demonstrated live                                                               | Releases tagged; rollback documented but untested                     | No release process or rollback plan                     |
| Reliability and incident handling     | 10  | High success rate; flaky tests fixed; every incident logged with a useful postmortem                                                        | Most failures addressed; some incidents logged                        | Frequently broken pipeline; incidents ignored           |
| Metrics, documentation, and reporting | 10  | Metrics log complete every sprint; clear PIPELINE.md, diagram, and runbook; strong weekly DevOps reports                                    | Documentation and metrics mostly complete                             | Sparse or missing documentation and metrics             |
| Live performance                      | 5   | Narrates the live deploy challenge confidently; answers pipeline questions with depth                                                       | Deploy succeeds; some hesitation in answers                           | Struggles to explain or operate the pipeline            |

**What separates an excellent DevOps grade from a passing one is evidence of improvement.** A pipeline that ends at 4 minutes because you brought it down from 14, with a log showing how, beats one that was set up once in Sprint 1 and never touched.

## 9. Grading Breakdown and Deliverables

Your final project grade combines team scores and an individual score, so a strong team can't carry an absent member and a strong individual isn't sunk by one bad sprint.

| Component                                    | Score type                  | Raw points  | Weight |
| -------------------------------------------- | --------------------------- | ----------- | ------ |
| Weekly consultations (4 sprints)             | Team, adjustable per member | 4 × 20 = 80 | 30%    |
| Final presentation (Demo Day)                | Team                        | 100         | 40%    |
| Individual track (Developer or CI/CD rubric) | Individual                  | 100         | 30%    |

Each component is converted to a percentage, then weighted. For example, a student with 70/80 on consultations (87.5%), 85/100 on Demo Day, and 90/100 on their individual track earns 0.30 × 87.5 + 0.40 × 85 + 0.30 × 90 = 87.25%.

### **Final deliverables checklist**

Submit the repository link and production URL before code freeze. Everything below should be in the repository or linked from the README.

**Product**

- ☐ Production URL of the tagged release
- ☐ Source code for frontend, backend, and database migrations
- ☐ .env.example listing every required variable, with no real values
- ☐ Seed data or a setup script so a reviewer can run it locally

**Documentation**

- ☐ README: what the app does, team roles, tech stack, setup and run instructions
- ☐ Architecture diagram
- ☐ Database schema diagram or outline
- ☐ API reference (for example, an OpenAPI spec or a documented endpoint list)
- ☐ AI feature write-up: approach, prompts or tools used, how output is processed, evaluation results, known limitations
- ☐ Changelog for the release

**Process evidence**

- ☐ Project board with sprint history
- ☐ Sprint log: four sprint plans, standup notes, and four retrospectives
- ☐ Scope change log, if your project changed from the pitch

**DevOps (owned by the DevOps Engineer)**

- ☐ Pipeline configuration files
- ☐ PIPELINE.md and pipeline diagram
- ☐ Completed pipeline metrics log
- ☐ Optimization log with before-and-after numbers
- ☐ Deploy and rollback runbook
- ☐ Incident log with postmortems

**Presentation**

- ☐ Slide deck
- ☐ A way to simulate an AI provider failure during the demo

## 10. FAQ

**Can we use a framework, language, database, or AI provider we didn't use in class?**

Yes. Use whatever fits your product. Be ready to explain why you chose it over the alternatives.

**Can we use AI coding assistants?**

Yes, the same way professional teams do. You are still responsible for every line you merge. If you can't explain it at consultation or Demo Day, it counts against you.

**Can we change our project from what we pitched?**

Yes. Real products change as teams learn. Record what changed and why in your scope change log, and tell the instructor at your next consultation. Dropping a core requirement from Section 3 is not allowed.

**Does the DevOps Engineer have to write application code?**

No, though they may. Their individual grade comes only from the CI/CD rubric. Developers shouldn't offload their own work onto the DevOps Engineer.

**What if our AI provider costs money?**

Use free tiers, trial credits, or a local model if you prefer. Set spending limits on every key. Mocking LLM calls in your tests will keep CI costs near zero.

**What if a teammate isn't contributing?**

Raise it early with the instructor, not at Demo Day. The repository history and board make contribution visible, and individual scores reflect it.

**What if our deployment breaks right before a consultation?**

Present it honestly. Show the incident, your diagnosis, and your fix or rollback. Handling a failure well is part of what's being graded, especially for the DevOps Engineer.

**What if production goes down during Demo Day?**

Roll back to the last good release and keep going. A team that recovers calmly scores better than one that pretends nothing happened.
