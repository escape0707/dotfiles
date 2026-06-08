# Codex Agent Guidelines

## Docs & API references (Context7)

Always use ctx7 cli when I need library/API documentation, code generation, setup or configuration steps without me explicitly asking. It's installed
globally already.

```shell
ctx7 --help
...
ctx7 library [options] <name> ["<query>"]    Resolve a library name to a Context7 library ID
ctx7 docs [options] <libraryId> "<query>"  Query documentation for a library
...
```

## Tooling

- Environment: Codex App on Windows 11 or codex on ArchLinux WSL2.
- Windows sandbox: escalate commands that invoke `wsl.exe`.
- In ArchLinux WSL2, use rootless Podman instead of Docker when needed.
- Testcontainers can use rootless Podman with `DOCKER_HOST=unix:///run/user/1000/podman/podman.sock` and Ryuk.
- Shells: `bash` is the login shell; `fish` is the interactive shell that I always use. Consider that before giving me scripts to run manually.
- TypeScript: `fnm`, `pnpm`, `ESLint`, `typescript-eslint`, `Prettier`.
- Python: `uv`, `ruff`, `pyrefly`.
- Markdown: VS Code `markdownlint` and `markdownlint-cli2`.
- Prefer modern CLI tools: `rg` over `grep`, `fd` over `find`, `jq`, and `gh`. If missing, stop and tell me to install them.

## Approval Prompts Reviewability

- Prefer KISS commands over compound/long oneline command.
- Parallelize order independent commands with multi_tool_use.parallel.
- Delay destructive cleanup (`rm -rf`, `Remove-Item -Recurse`, etc.) to the last multi_tool_use.parallel possible.
- Prefer long-form command flags over short aliases. Expect for `sed -n`.

## Scaffolding & Dependencies

- Prefer me manually run official init/create commands for scaffolding, dependency installation, and base config.
- If an init/create command is interactive, tell me what to run, what to expect, and which options to choose; then wait for me to finish.
- If new dependencies are needed, ask me to run the install command manually. Do not work around missing tooling with lower-fidelity hacks if proper dependencies are the right answer.

## Protected Files

- Never create, edit, or delete dependency definition files, lock files, or project/toolchain configuration files unless I explicitly ask for that class of change.
- This includes package/dependency manifests, lock files, compiler configs, build-system files, formatter/linter/test-runner configs, environment/toolchain selectors, and similar project-definition files across JavaScript/TypeScript, Python, Rust, Go, C/C++, and related ecosystems.
- Examples include `package.json`, `pnpm-lock.yaml`, `tsconfig*.json`, `pyproject.toml`, `uv.lock`, `requirements*.txt`, `Cargo.toml`, `Cargo.lock`, `rust-toolchain*`, `go.mod`, `go.sum`, `CMakeLists.txt`, `Makefile`, `meson.build`, `.clang-format`, `.clang-tidy`, and similar files.
- One exception is the `scripts` section of `package.json`.
- If such files need to change, stop, explain why, and ask me to do the edit or install step manually.

## Branch Naming

- When creating branches, use `codex/` followed by kebab-case words.

## Git Note

- Prefer using `gh` for GitHub inspection and workflow tasks. Prefer purpose-built CLI subcommands over `gh api` for easier approval-rule matching when practical.
- For remote source inspection, prefer cloning the repository into `~/workspaces/<repo-main-language-abbr>/<repo>` and inspecting or updating the local checkout instead of using raw API file reads.
- If `gh api` is genuinely required to get complete context or finish the job without losing important information, pause and suggest the exact command for me to run manually.
- Prefer SSH Git remote URLs for GitHub/GitLab clone, fetch, and push operations. Use HTTPS for browser links, API endpoints, documentation, or when SSH authentication is unavailable.
- Respect my git triangular fork workflows:
  - Configure remotes as:
    - origin: my fork
    - upstream: upstream repo (with `upstream no_push (push)`)
  - Global git config has `remote.pushDefault=origin`, `push.default=current` already.
  - Set local branch to track `upstream` not `origin`.
  - Then `git push` and `git pull` will run for triangular fork workflows as expected.
- Run `git push` with sandbox escalation because `.git/refs/remotes/*` is not writable in the sandbox.
- During active PR or feature work, do not amend commits by default. Make new commits while iterating, then rewrite/squash only at the end once the direction is settled, unless explicitly asked to amend or rewrite earlier.
- When filing issues, pull requests, etc, always try to follow upstream's contribution guidelines and the relevant (GitHub/GitLab) templates before submitting.
- When checking for GitHub issue templates, inspect `.github/ISSUE_TEMPLATE/`, `.github/ISSUE_TEMPLATE/config.yml`, and `.github/pull_request_template*` directly.
- Redact personal, private, or machine-specific information before sharing content externally, including usernames, home-directory paths, hostnames, tokens, account IDs, private repository names, local IPs when not necessary, and any secret-like values. Prefer placeholders such as `<user>`, `<host>`, `<token>`, `<repo>`, or `<path>` when exact values are not required.
- When referring to remote source code in issues, pull requests, reviews, or durable documentation, prefer permanent links pinned to a commit SHA over moving branch links such as `main`, `master`, or `HEAD`, so readers see the same code later.
- On Windows PowerShell, quote comma-separated `gh --json` field lists, e.g. `--json "number,title,state"` to avoid rule pattern matching bug.
- You struggle with interactive `git rebase --continue`; use
  `git -c core.editor=true rebase --continue`.

## Git History Quality

- When reviewing a branch for merge, evaluate whether the commit history reflects durable project history or temporary review scaffolding.
- If the branch contains rename-only commits, temporary planning artifacts, vague commit messages, or iterative cleanup churn, prefer recommending a rewrite into a smaller set of higher-signal commits before merge.
- Do not default automatically to either keeping noisy history or squashing everything into one commit.
- When appropriate, preserve 2-3 meaningful phases as separate commits if they represent durable story beats.
- Prefer squash-on-merge mainly when the branch is mostly iterative noise or the repository intentionally follows a one-change-one-commit policy.
