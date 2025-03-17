#! /usr/bin/env make
.DEFAULT_GOAL := all

VARIANT := debug
# or release - do not put a space after debug
TARGET := x86_64-unknown-linux-gnu

.PHONY: init
init:
	git submodule update --init --recursive

.PHONY: all
all:
	@echo Building variant: ${VARIANT}
	dotenvx run -- npm run build --workspaces
	dotenvx run -- cmake -S . -B ./out/build/${VARIANT}-${TARGET} --preset=${VARIANT}-${TARGET}
	dotenvx run -- cmake --build ./out/build/${VARIANT}-${TARGET}
	dotenvx run -- cargo build --target ${TARGET} 
	dotenvx run -- swift build --configuration ${VARIANT}

.PHONY: run
run: all
	dotenvx run -- swift run

.PHONY: clean
clean:
	cargo clean
	swift package clean
	rm -rf out
	rm -f *.d *.o *.swiftdeps *.swiftdeps~

.PHONY: frontend-dev
frontend-dev: all
	(dotenvx run -- swift run)&
	(cd Sources/lxui/; npm run dev)

.PHONY: clean-build
clean-build: clean all