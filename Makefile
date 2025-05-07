#! /usr/bin/env make
.DEFAULT_GOAL := all

SHELL = /usr/bin/env sh
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
	git submodule update --init --recursive
	npm install --workspaces
	cargo fetch

.PHONY: frontend
frontend:
	npm run build --workspaces --${VARIANT}

.PHONY: backend
backend:
	cmake -S . -B ./out/build/${VARIANT} --preset=${VARIANT}
	cmake --build ./out/build/${VARIANT}
	cargo build ${CARGO_RELEASE_FLAG}
	CC=clang CXX=clang++ swift build --configuration ${VARIANT}

.PHONY: ${ARTIFACT}
${ARTIFACT}: frontend backend

.PHONY: all
all: ${ARTIFACT}

.PHONY: test
test: all
	cargo test
	npm run test --workspaces
	CC=clang CXX=clang++ swift test

.PHONY: everything
everything: init all
	cp .build/${VARIANT}/LX .

.PHONY: run
run: all
	CC=clang CXX=clang++ dotenvx run -- swift run

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
	CC=clang CXX=clang++ dotenvx run -f .env.development -- swift run

.PHONY: install
install: all
	cp ${ARTIFACT} ${INSTALL_DIR}

.PHONY: install-static-swift-sdk
install-static-swift-sdk:
	swift sdk install https://download.swift.org/swift-6.1-release/static-sdk/swift-6.1-RELEASE/swift-6.1-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz --checksum 111c6f7d280a651208b8c74c0521dd99365d785c1976a6e23162f55f65379ac6

.PHONY: install-debian-packages
install-debian-packages: install-static-swift-sdk
# optimized for bookworm
	apt install -y npm nix cmake wget zsh zip gdb git ninja-build swi-prolog build-essential gnustep-core-devel gnustep-core-doc gobjc gobjc++
	nix --extra-experimental-features 'nix-command flakes' profile install \
		nixpkgs#nodejs_23 			\
		nixpkgs#dotenvx 			\
		nixpkgs#wasm-pack			\
		nixpkgs#cargo				\
		nixpkgs#rustc

.PHONY: install-rhel-packages
install-rhel-packages: install-static-swift-sdk
# optimized for rhel9
	dnf module enable -y nodejs:20
	dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
	dnf install -y npm cmake git ninja-build gcc gcc-c++ gcc-objc gcc-objc++ gdb wget zsh zip gnustep-base-devel
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
	~/.cargo/bin/cargo install wasm-pack


.PHONY: install-linux-packages
install-linux-packages:
	@if [ -f /etc/debian_version ]; then \
		echo "Installing packages for debian"; \
		$(MAKE) install-debian-packages; \
	elif [ -f /etc/redhat-release ]; then \
		echo "Installing packages for redhat"; \
		$(MAKE) install-rhel-packages; \
	else \
		echo "Unsupported Linux distribution"; \
		exit 1; \
	fi