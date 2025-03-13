# TODO call this from Package.swift and remove swift build

all:
	dotenvx run -- npm run build --workspaces
	dotenvx run -- cmake -S . -B ./out/build/debug-x86-64-unknown-linux-gnu --preset=debug-x86-64-unknown-linux-gnu
	dotenvx run -- cargo build
	dotenvx run -- swift build

run: all
	dotenvx run -- swift run