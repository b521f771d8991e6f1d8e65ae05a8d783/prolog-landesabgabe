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

.PHONY: init
init:
	git submodule update --init --recursive

.PHONY: all
all:
	@echo Building variant: ${VARIANT} for target ${TARGET}
	npm run build --workspaces --${VARIANT}
	cmake -S . -B ./out/build/${VARIANT}-${TARGET} --preset=${VARIANT}-${TARGET}
	cmake --build ./out/build/${VARIANT}-${TARGET}
	cargo build --target ${TARGET} ${CARGO_RELEASE_FLAG}
	swift build --configuration ${VARIANT}

.PHONY: run
run: all
	dotenvx run -- swift run

.PHONY: clean
clean:
	cargo clean
	swift package clean
	rm -rf out .build target
	rm -f *.d *.o *.swiftdeps *.swiftdeps~

.PHONY: clean-build
clean-build: clean all

.PHONY: frontend-dev
frontend-dev: all
	(dotenvx run -- swift run)&
	(cd Sources/lxui/; npm run dev)

.PHONY: clean-build
clean-build: clean all