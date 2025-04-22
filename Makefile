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

.PHONY: init
init:
	npm install --workspaces
	cargo fetch
	git submodule update --init --recursive

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
all: init frontend backend

.PHONY: run
run: all
	dotenvx run -- swift run

.PHONY: clean
clean:
	swift package clean
	cargo clean
	rm -rf out .build target Sources/generated *.o *.swiftdeps* *.d

.PHONY: clean-build
clean-build: clean all

.PHONY: frontend-dev
frontend-dev: frontend
	npm run dev --workspaces

.PHONY: backend-dev
backend-dev: backend
	dotenvx run -f .env.development -- swift run
