#! /usr/bin/env make
.DEFAULT_GOAL := all

SHELL = /usr/bin/zsh
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

.PHONY: all
all: init
	@echo Building variant: ${VARIANT} for target ${TARGET}
	npm run build --workspaces --${VARIANT}
	cmake -S . -B ./out/build/${VARIANT}-${TARGET} --preset=${VARIANT}-${TARGET}
	cmake --build ./out/build/${VARIANT}-${TARGET}
	swift build --configuration ${VARIANT}

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
frontend-dev: all
	npm run dev --workspaces

.PHONY: backend-dev
backend-dev: all
	dotenvx run -- swift run

.PHONY: clean-build
clean-build: clean all