# Agents Guide

## Project Structure

- `corpus/` — Prolog law corpus (`.pl` files), embedded at build time via Vite `?raw` imports
- `corpus/stdlib/` — shared Prolog modules (bergbau, abgabe, gebietskoerperschaften, etc.)
- `corpus/tests/` — test sachverhalte (Prolog fact files for testing)
- `src/` — React/TypeScript frontend
- `src/corpus/index.ts` — re-exports all `.pl` files as strings for the frontend bundle
- `flake.nix` — Nix build (frontend-only, no backend)
- `wrangler.jsonc` — Cloudflare Workers deployment config

## Build & Test

- `npm install` — install dependencies
- `npm run dev` — start dev server
- `npm run build:web` — production build
- `npm test` — run vitest tests
- `nix build .#frontend` — Nix build (static output)
- `nix run` — serve the built frontend on localhost:8080

## Important: Always verify `nix build` after changes

When modifying file paths, imports, or project structure, **always run `nix build .#frontend`** to verify the build succeeds in the Nix sandbox. The Nix build is stricter than local `npm run build:web` because:

1. **No access to untracked files** — Nix copies the source tree from git, so untracked/gitignored files won't exist
2. **No network access** — all dependencies must be declared in `npmDeps`
3. **TypeScript strict mode** — `tsc` runs before `vite build`, catching type errors that `vite dev` might skip
4. **Import paths must be correct** — relative imports that happen to work locally (e.g., resolving through symlinks) will fail in the sandbox

Common issues:
- Moving files without updating all import paths → TS2307 "Cannot find module"
- Importing from `generated/` directories that only exist after a backend build → remove or replace these imports
- Trailing commas in `package.json` → esbuild rejects them

## Architecture Notes

- **No backend** — all Prolog execution happens in the browser via `swipl-wasm` or `scryer` (npm package)
- **Scryer Prolog** is lazy-loaded via dynamic `import()` in `Home.page.tsx` to avoid bundling it when using SWI-Prolog
- The Prolog corpus files are embedded as raw strings at build time, not fetched from a server
