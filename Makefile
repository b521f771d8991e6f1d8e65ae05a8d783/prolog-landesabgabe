#! /usr/bin/env make
.DEFAULT_GOAL := all

SHELL = /usr/bin/env zsh
VARIANT ?= debug
# or release - do not put a space after debug
TARGET ?= x86_64-unknown-linux-gnu

# some tools require special treatment 🦄
ifeq ($(VARIANT),release)
	CARGO_RELEASE_FLAG := --release
else
	CARGO_RELEASE_FLAG :=
endif

.PHONY: git-init
git-init:
	git submodule update --init --recursive

.PHONY: init
init:
	npm install --workspaces

.PHONY: frontend
frontend:
	npm run build --workspaces --${VARIANT}

.PHONY: backend
backend:
	cmake -S . -B ./out/build/${VARIANT}-${TARGET} --preset=${VARIANT}-${TARGET}
	cmake --build ./out/build/${VARIANT}-${TARGET}
	cargo build
	swift build --configuration ${VARIANT}

.PHONY: all
all: frontend backend

.PHONY: run
run: all
	dotenvx run -- swift run

.PHONY: clean
clean:
	swift package clean
	rm -rf out .build

.PHONY: clean-build
clean-build: clean all

.PHONY: frontend-dev
frontend-dev: frontend
	npm run dev --workspaces

.PHONY: backend-dev
backend-dev: backend
	dotenvx run -f .env.development -- swift run

.PHONY: clean-build
clean-build: clean all