import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import tsconfigPaths from "vite-tsconfig-paths";
import wasm from "vite-plugin-wasm";

export default defineConfig(({ command }) => {
	const isBuild = command === "build";

	return {
		plugins: [react(), tsconfigPaths(), wasm()],
		test: {
			globals: true,
			environment: "jsdom",
			setupFiles: "./vitest.setup.mjs",
			include: ["src/**/*.test.{ts,tsx}"],
		},
		build: {
			minify: true,
			target: "ES2022",
		},
		esbuild: isBuild
			? {
					// removes all logs from the build
					drop: ["console", "debugger"],
				}
			: {},
	};
});
