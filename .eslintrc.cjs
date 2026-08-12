module.exports = {
  root: true,
  env: {
    node: true,
    es2022: true,
  },
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 2022,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint'],
  extends: ['eslint:recommended', 'plugin:@typescript-eslint/recommended'],
  rules: {
    '@typescript-eslint/no-unused-vars': [
      'error',
      { argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
    ],
    '@typescript-eslint/no-explicit-any': 'warn',
  },
  ignorePatterns: [
    'node_modules',
    'dist',
    'build',
    '.git',
    // Legacy Phase 1 source (no package.json yet). Integration into
    // workspace packages happens in Chat 2/3 — see docs/decisions.md
    'packages/core/federation',
    'packages/core/memory',
    'packages/core/swarm',
    'packages/core/trust-domains',
    'packages/tools/browser',
    'packages/tools/filesystem',
    'packages/tools/github',
    'packages/tools/shell',
    'packages/llm-router/auto-combo',
    'packages/llm-router/budget',
    'packages/llm-router/config',
    'packages/llm-router/rotation',
    'packages/traces/trace',
  ],
};
