#! /usr/bin/env make
.DEFAULT_GOAL := all

SHELL = /usr/bin/env sh
VARIANT ?= debug
TARGET ?= x88_64-unknown-linux-gnu
# or release - do not put a space after debug
INSTALL_DIR ?= /usr/local/bin

# some tools require special treatment 🦄
ifeq ($(VARIANT),release)
	CARGO_RELEASE_FLAG := --release
else
	CARGO_RELEASE_FLAG :=
endif	

.PHONY: init
init:
	git submodule update --init --recursive
	npm install --workspaces
	cargo fetch
	swift package resolve

.PHONY: frontend
frontend:
	npm run build --workspaces --${VARIANT}

.PHONY: backend
backend:
	cargo build ${CARGO_RELEASE_FLAG}
	swift build --configuration ${VARIANT}

.PHONY: all
all: frontend backend

.PHONY: test
test: all
	cargo test
	npm run test --workspaces

.PHONY: clean
clean:
	cargo clean
	rm -rf out .build target Sources/generated *.o *.d npm-pkgs node_modules .build

.PHONY: clean-build
clean-build: clean all

.PHONY: frontend-dev
frontend-dev: frontend
	npm run dev --workspaces

.PHONY: backend-dev
backend-dev: backend
	cargo run --package backend