import mantine from 'eslint-config-mantine';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  ...mantine,
  { ignores: ['**/*.{mjs,cjs,js,d.ts,d.mts}', './.storybook/main.ts'] },
  {
    "plugins": [
      "office-addins"
    ],
    "extends": [
      "plugin:office-addins/recommended"
    ],
    "env": {
      "node": true,
      "browser": true
    },
    "rules": {
      "no-dupe-class-members": "off",
      "@typescript-eslint/no-dupe-class-members": "error",
      "max-lines-per-function": ["error", { "max": 20, "skipBlankLines": true, "skipComments": true }], // Lukas will enjoy this
      "eslint func-style": ["error", "declaration", { "overrides": { "namedExports": "expression" } }],
    },
  }
);