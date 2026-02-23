# AGENTS.md

This document provides guidance for AI coding agents working in this repository.

## Project Overview

A full-stack legal decision system implementing Upper Austrian landscape tax law (Oö. Landschaftsabgabegesetz). It combines a sandboxed Prolog logic engine with a Rust/Actix-web backend and a React/TypeScript frontend.

**Languages:** Rust, TypeScript, Prolog, Swift
**Key technologies:** Actix-web, React, Mantine UI, SWI-Prolog (WASM), deno_core, Keycloak, Vite

## Repository Structure

```
Sources/
  Backend/           # Rust HTTP server (Actix-web)
  BackendInterfaces/ # Shared Rust data types between crates
  BuildInformation/  # Rust build metadata
  PrologVM/          # Sandboxed Rust Prolog VM (deno_core)
  LogicKit/          # TypeScript bindings to Prolog runtime
  WebUI/             # React + TypeScript frontend (Mantine UI)
  Corpus/            # Prolog law rule files (stdlib)
  ActKit/            # Swift actor-based utilities
  Docker/            # Docker Compose for local dev
Tests/
  ActKitTests/       # Swift tests
  Corpus/            # Prolog corpus tests
Dependencies/        # vcpkg submodule (C++ packages)
```

## Build & Development Commands

### First-time setup
```bash
make init
```
This runs: `git submodule update --init --recursive`, `npm install --workspaces`, `cargo fetch`, `swift package resolve`.

### Build everything
```bash
VARIANT=debug make all    # debug build (default)
VARIANT=release make all  # release/production build
```

### Build individual components
```bash
make frontend       # React app → generated/web-dist/frontend
make backend        # Rust backend + Swift
make cmake-projects # C++ targets via CMake
```

### Development servers
```bash
make frontend-dev   # Vite dev server on port 4434
make backend-dev    # Rust backend in watch/dev mode
```

### Docker
```bash
# Local dev stack
cd Sources/Docker && docker-compose up

# Production image
VARIANT=release make linux-packages
docker build -t prolog-landesabgabe .
```

## Running Tests

```bash
make test
```
This runs all Rust and TypeScript/React tests together. Run individual suites:

```bash
# Rust only
cargo test

# Frontend only (from Sources/WebUI)
npm run vitest
npm run vitest:watch     # watch mode
npm run typecheck        # TypeScript compilation check
npm run prettier         # formatting check
npm run lint             # ESLint + Stylelint

# Full frontend CI pipeline
npm run build
```

## Code Style & Formatting

- **TypeScript/JavaScript:** ESLint (see `eslint.config.mjs`) + Prettier (see `.prettierrc`)
  - Tabs for indentation, 80-char line limit, single trailing commas, single quotes
- **Rust:** standard `rustfmt` (Edition 2024)
- **CSS/SCSS:** Stylelint

Always run `npm run prettier` and `npm run lint` in `Sources/WebUI` before committing frontend changes. Run `cargo fmt` and `cargo clippy` before committing Rust changes.

## Environment Variables

Runtime config uses two prefixes:
- `LX_` — backend runtime vars (Keycloak URLs, JWT roles, CORS, ports)
- `VITE_` — frontend build-time constants

The `.env` file documents available variables. `APP_CONFIG_EXPORT_TO_FRONTEND_PREFIXES` controls which variables are forwarded to the frontend.

## Architecture Notes

### Backend (Rust)
- Actix-web with Keycloak middleware for OAuth2/OIDC
- API routes under a configurable prefix (default: `api`)
- Serves embedded frontend assets via `rust-embed`
- Diesel ORM for database access
- Health check: `GET /health` → JSON

### Frontend (React)
- Dev proxy: `/api/*` → `localhost:1337` (configured in `vite.config.mjs`)
- TanStack Query for server state; React Router 7 for routing
- Path alias `@/*` → `src/*`
- Storybook available for component development

### Prolog Integration
- Browser: `swipl-wasm` runs SWI-Prolog in WebAssembly
- Server: `PrologVM` crate wraps a sandboxed Prolog engine via `deno_core`
- `LogicKit` (TypeScript) exposes `runQuery(laws: string[], query: string, key: string)`
- Law rules live in `Sources/Corpus/stdlib/`

### Build Variants
`VARIANT=debug` vs `VARIANT=release` controls Rust `--release` flag and CMake configuration throughout the entire build pipeline.

## CI/CD

- `.github/workflows/build_worker.yml` — triggered on pushes to `stable`, `dev`, `beta`; builds and pushes Docker image to `containers.github.scch.at/land-ooe/lx-worker`
- `.github/workflows/npm_test.yml` — runs on all PRs; executes frontend build + tests
- Dependabot: weekly updates for `npm` and `cargo`, targeting `dev` branch

## Key Conventions

- Workspace root `Cargo.toml` manages all Rust crates; add new crates there
- npm workspaces: `Sources/WebUI` and `Sources/LogicKit` are separate packages
- Swift package (`Package.swift`) manages `ActKit` and its tests
- Prolog files under `Sources/Corpus/` follow the law corpus structure — do not move or rename them without updating references in `LogicKit` and `PrologVM`
- Do not commit secrets or real Keycloak credentials; use `.env` for local overrides only
