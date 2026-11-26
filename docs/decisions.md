# Design decisions

Each entry says what was decided, what was rejected, and why.

## D1. Pin `sqlglot` and `mcp` to exact versions

The safety checks depend on the shape of the syntax tree sqlglot produces, and sqlglot changes node types between releases. Pinning with `==` instead of a range means an upgrade is a deliberate edit, followed by a full run of the safety tests. `mcp` is pinned the same way because its server API already changed once (FastMCP in 1.x became MCPServer in 2.x). Everything else has a lower bound only; `uv.lock` holds the exact versions.

## D2. Pin GitHub Actions to commit SHAs

CI references `actions/checkout` and `astral-sh/setup-uv` by full commit SHA, with the version in a comment, instead of a tag like `v7`. Whoever controls an action's repo can move a tag to new code, as happened in the 2025 `tj-actions/changed-files` compromise; a SHA can't be moved. The cost is bumping two SHAs by hand now and then.

## D3. Use a plain uv app layout, no build backend

`server`, `agent`, `evals` and `db` are top-level directories imported from the repo root (pytest uses `pythonpath = ["."]`, and the agent runs as `python -m agent`). The project itself is never installed as a package. A `src/` layout with a build backend was the alternative, but it adds packaging steps and buys nothing here, since nothing gets published.
