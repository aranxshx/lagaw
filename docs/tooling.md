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
