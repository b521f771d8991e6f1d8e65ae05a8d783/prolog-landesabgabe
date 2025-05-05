import { defineConfig } from "eslint/config";
import js from "@eslint/js";
import globals from "globals";
import tseslint from "typescript-eslint";
import pluginReact from "eslint-plugin-react";
import json from "@eslint/json";
import markdown from "@eslint/markdown";
import css from "@eslint/css";
import stylisticJs from "@stylistic/eslint-plugin-js";

export default defineConfig([
    {
        files: ["**/*.{js,mjs,cjs,ts,jsx,tsx}"],
        plugins: { js, "@stylistic/js": stylisticJs, react: pluginReact },
        extends: ["js/recommended", "plugin:react/recommended"],
        rules: {
            semi: ["error", "always"],
            quotes: ["error", "double"],
            "comma-dangle": ["error", "always-multiline"],
            "indent": ["error", 2],
            "no-trailing-spaces": "error",
            "arrow-parens": ["error", "as-needed"],
            "space-infix-ops": "error",
            "keyword-spacing": ["error", { before: true, after: true }],
            "no-multiple-empty-lines": ["error", { max: 1, maxEOF: 1 }],
            "object-curly-spacing": ["error", "always"],
            "react/react-in-jsx-scope": "off",
            "react/prop-types": "off",
            "react/jsx-uses-react": "off",
            "react/jsx-uses-vars": "error",
        },
    },
    {
        files: ["**/*.{js,mjs,cjs,ts,jsx,tsx}"],
        languageOptions: { globals: globals.browser },
        rules: {
            semi: ["error", "always"],
            "eol-last": ["error", "always"],
            "space-before-blocks": ["error", "always"],
        },
    },
    {
        files: ["**/*.json"],
        plugins: { json },
        language: "json/json",
        extends: ["json/recommended"],
    },
    {
        files: ["**/*.jsonc"],
        plugins: { json },
        language: "json/jsonc",
        extends: ["json/recommended"],
    },
    {
        files: ["**/*.json5"],
        plugins: { json },
        language: "json/json5",
        extends: ["json/recommended"],
    },
    {
        files: ["**/*.md"],
        plugins: { markdown },
        language: "markdown/commonmark",
        extends: ["markdown/recommended"],
    },
    {
        files: ["**/*.css"],
        plugins: { css },
        language: "css/css",
        extends: ["css/recommended"],
    },
]);
