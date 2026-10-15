# Tooling setup

Team setup for the tools every contributor (and their AI agent) should have. `AGENTS.md` instructs agents to use these, so a missing install means slower, less accurate agents.

## CodeGraph

[CodeGraph](https://github.com/colbymchenry/codegraph) indexes the codebase into a local knowledge graph, so agents answer structural questions (call paths, dependencies, blast radius) in one call instead of reading file after file. It runs 100% locally, and the index in `.codegraph/` is gitignored — nothing is committed.

1. **Install the CLI**

   Windows (PowerShell):
   ```powershell
   irm https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.ps1 | iex
   ```

   macOS / Linux:
   ```sh
   curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh
   ```

   Or with Node installed: `npm i -g @colbymchenry/codegraph`

   Open a new terminal afterwards so `codegraph` resolves on your PATH.

2. **Wire it into your agent**: run `codegraph install` — it detects and configures Claude Code, Cursor, Codex CLI, opencode, Gemini CLI, Copilot, and others automatically. Restart the agent afterwards.

3. **Initialize this project** (once per clone): run `codegraph init` in the repository root. It creates `.codegraph/` and builds the full graph, then auto-syncs on every file change — nothing to re-run.

4. **Verify** with `codegraph status`; update with `codegraph upgrade`.

## Wrangler (Cloudflare Pages)

[Wrangler](https://developers.cloudflare.com/workers/wrangler/) is Cloudflare's CLI. Lagaw uses it to create, deploy, and inspect the Cloudflare Pages project that hosts the Flutter Web build. The DevOps Engineer owns the Cloudflare account and deploy token; other contributors only need Wrangler if they deploy a preview by hand.

1. **Prerequisite**: Node.js (current LTS) and npm.

2. **Install**: `npm i -D wrangler` in the repository root, so everyone and CI share one pinned version. Run it with `npx wrangler ...`. A global install (`npm i -g wrangler`) also works.

3. **Authenticate**: `npx wrangler login` opens a browser sign-in; confirm with `npx wrangler whoami`. For CI and other non-interactive use, set `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` in the environment instead. Never commit either value.

4. **Common commands**
   ```sh
   npx wrangler pages project create lagaw --production-branch main   # once
   flutter build web
   npx wrangler pages deploy build/web --project-name lagaw --branch <branch>
   npx wrangler pages deployment list --project-name lagaw
   ```

Deploys from `main` go to production; other branches get a preview URL. See [the pitch](pitch.md#hosting-plan) for the full DevOps plan.

## ripgrep and fd

`rg` replaces `grep`, and `fd` replaces `find`/glob file discovery — both faster and `.gitignore`-aware. Agents are instructed to use these instead of the built-in grep/glob tools.

Windows:
```
winget install BurntSushi.ripgrep.MSVC
winget install sharkdp.fd
```

macOS: `brew install ripgrep fd`

Debian / Ubuntu: `sudo apt install ripgrep fd-find` (the binary is `fdfind` there — symlink or alias it to `fd` if you prefer the usual name)

Any platform with Cargo: `cargo install ripgrep fd-find`

Verify with `rg --version` and `fd --version`.
