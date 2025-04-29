#! /usr/bin/env make
.DEFAULT_GOAL := all

SHELL = /usr/bin/env zsh
VARIANT ?= debug
# or release - do not put a space after debug
INSTALL_DIR ?= /usr/local/bin

# some tools require special treatment 🦄
ifeq ($(VARIANT),release)
	CARGO_RELEASE_FLAG := --release
else
	CARGO_RELEASE_FLAG :=
endif

ARTIFACT := .build/${TARGET}/LX

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
	cmake -S . -B ./out/build/${VARIANT} --preset=${VARIANT}
	cmake --build ./out/build/${VARIANT}
	cargo build ${CARGO_RELEASE_FLAG}
	swift build --configuration ${VARIANT}

.PHONY: ${ARTIFACT}
${ARTIFACT}: frontend backend

.PHONY: all
all: ${ARTIFACT}

.PHONY: test
test: all
	cargo test
	npm run test --workspaces
	swift test

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

.PHONY: install
install: all
	cp ${ARTIFACT} ${INSTALL_DIR}