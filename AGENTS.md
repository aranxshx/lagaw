# AGENTS.md

Guidance for AI coding agents working in this repository.

## Ground truth

Always treat these documents as the source of truth for what Lagaw is and what it must do:

- [`docs/pitch.md`](docs/pitch.md) — the approved pitch: scope, AI feature, database schema, tech stack, and environment plan.
- [`docs/official-instructions.md`](docs/official-instructions.md) — the official course instructions: requirements, sprints, and grading rubrics.

Read them before planning or changing anything. If code, comments, or other docs conflict with them, follow these documents and flag the conflict rather than working around it.

## Codebase traversal (mandatory)

This repository is indexed with CodeGraph. Use these tools, in this order:

1. **CodeGraph for anything structural** — how something works, what calls what, dependencies, imports, blast radius. Prefer the CodeGraph MCP tool (`codegraph_explore`); without MCP, use the CLI (`codegraph explore`, `codegraph callers`, `codegraph impact`). Treat returned source as already read; don't re-verify it with search.
2. **`rg` (ripgrep) for content search** — never `grep`, or the built-in grep tool.
3. **`fd` for finding files** — never `find`, glob patterns, or the built-in glob tool.
4. Only if a tool is genuinely missing (`where rg` on Windows, `which rg` elsewhere): fall back to shell `grep`/`find`, never the built-in tools.

If `.codegraph/` is missing, run `codegraph init` in the repository root first. Setup for all of this: [`docs/tooling.md`](docs/tooling.md).

## Git conventions

Follow the branch strategy in [`README.md`](README.md#branch-strategy):

- Never commit directly to `main`; every change goes through a pull request.
- Name branches `feat/<name>`, `fix/<name>`, `chore/<name>`, `docs/<name>`, or `test/<name>`.
- Keep `main` stable and deployable; wait for CI to pass before merging.