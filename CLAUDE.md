# Project: prolog-landesabgabe

## Project Structure

- `corpus/` — Prolog law corpus (`.pl` files), embedded at build time via Vite `?raw` imports
- `corpus/stdlib/` — shared Prolog modules (bergbau, abgabe, gebietskoerperschaften, etc.)
- `corpus/tests/` — test sachverhalte (Prolog fact files for testing)
- `src/` — React/TypeScript frontend
- `src/corpus/index.ts` — re-exports all `.pl` files as strings for the frontend bundle
- `flake.nix` — Nix build (frontend-only, no backend)
- `wrangler.jsonc` — Cloudflare Workers deployment config

## Commit rules

- NEVER add `Co-Authored-By` lines to commit messages. The user signs all commits with GPG — Claude is a tool, not a co-author.
- NEVER actually commit, just write the commit message
- Keep commit messages in English. Reference Austrian law identifiers (LGBl.Nr., BGBl., etc.) verbatim.

## Build & test

- `nix build` builds the frontend AND runs all vitest tests. It must pass before every commit (enforced by `.githooks/pre-commit`).
- Git hooks directory: `.githooks/` (configured via `core.hooksPath`).
- To run tests locally outside nix: `npm run vitest`
- `npm run dev` — start dev server
- `nix run` — serve the built frontend on localhost:8080

### Always verify `nix build` after changes

The Nix build is stricter than local `npm run build:web` because:

1. **No access to untracked files** — Nix copies the source tree from git, so untracked/gitignored files won't exist
2. **No network access** — all dependencies must be declared in `npmDeps`
3. **TypeScript strict mode** — `tsc` runs before `vite build`, catching type errors that `vite dev` might skip
4. **Import paths must be correct** — relative imports that happen to work locally will fail in the sandbox

Common issues:
- Moving files without updating all import paths → TS2307 "Cannot find module"
- Importing from `generated/` directories that only exist after a backend build → remove or replace these imports
- Trailing commas in `package.json` → esbuild rejects them

## Prolog corpus

- The law encoding lives in `corpus/labgg.pl`. The rate and legal text must match the current geltende Fassung on RIS.
- Current indexed rate: 20,74 Cent/tonne (K LGBl.Nr. 36/2025, ab 1. Jänner 2026) = 0.2074 EUR in code.
- `corpus/tests/labgg-output3.pl` is a concatenation of labgg.pl + sachverhalt3 — keep it in sync when editing labgg.pl.

## Architecture

- **No backend** — all Prolog execution happens in the browser via `swipl-wasm` or `scryer` (npm package)
- **Scryer Prolog** is lazy-loaded via dynamic `import()` in `Home.page.tsx` to avoid bundling it when using SWI-Prolog
- The Prolog corpus files are embedded as raw strings at build time, not fetched from a server

## Code style

- Do not add a Nix devshell. `nix develop` works without one.
- Do not modify `flake.nix` beyond what is necessary.
