#! /usr/bin/env make
.DEFAULT_GOAL := all

SHELL = /usr/bin/env sh
VARIANT ?= debug

SOURCES_DIR := Sources
CMAKE_DIRS := $(shell find $(SOURCES_DIR) -type f -name CMakeLists.txt -exec dirname {} \;)

OUT_DIR ?= out

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
	npm install
	cargo fetch
	swift package resolve

.PHONY: cmake-projects
cmake-projects:
	echo ${CMAKE_DIRS}
	@for i in $(CMAKE_DIRS); do \
		echo "Running cmake in $$i"; \
		VARIANT=${VARIANT} ${CMAKE} -S $$i -B .cmake/$$i; \
		VARIANT=${VARIANT} ${CMAKE} --build .cmake/$$i; \
	done

.PHONY: frontend
frontend:
	npm run build --workspaces --${VARIANT}

.PHONY: backend
backend: cmake-projects
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
	rm -rf out .build target *.o *.d npm-pkgs node_modules .build .cmake generated

.PHONY: clean-build
clean-build: clean all

.PHONY: frontend-dev
frontend-dev: frontend
	npm run dev --workspaces

.PHONY: backend-dev
backend-dev: backend
	cargo run --package backend

.PHONY: linux-packages
linux-packages: all
	VARIANT=${VARIANT} cmake -S . -B .cmake/root
	VARIANT=${VARIANT} cmake --build .cmake/root
	cd .cmake/root && cpack
	mkdir -p ${OUT_DIR}
	mv .cmake/root/*.deb .cmake/root/*.rpm .cmake/root/*.sh .cmake/root/*.tar.gz ${OUT_DIR}/