module.exports = {
  extends: 'eslint:recommended',
  parserOptions: {
    ecmaVersion: 8,
    sourceType: 'module',
    ecmaFeatures: {
      "experimentalObjectRestSpread": true
    }
  },
  rules: {
    // https://eslint.org/docs/rules/computed-property-spacing
    'computed-property-spacing': ['warn', "never"],
    // https://eslint.org/docs/rules/object-curly-spacing
    'object-curly-spacing': ['warn', 'always'],
    // https://eslint.org/docs/rules/array-bracket-spacing
    'array-bracket-spacing': ['warn', 'never'],
    'eol-last': ["warn", "always"],
    'global-require': 2,
    'default-case': 2,
    eqeqeq: [2, 'smart'],
    'no-eq-null': 2,
    strict: [2, 'global'],
    'callback-return': 2,
    'no-process-env': 2,
    'no-process-exit': 2,
    'no-var': 2,
    indent: ['error', 2],
    'prefer-const': 2,
    'no-unused-expressions': 2,
    semi: 2,
    'func-names': 1,
    'prefer-destructuring': 2,
    'object-shorthand': 2,
    quotes: ['error', 'single'],
    'no-buffer-constructor': 2,
    'linebreak-style': 2,
    'no-unused-expressions': 0,
    'chai-friendly/no-unused-expressions': 2,
    'no-process-env': 0,
    'comma-spacing': [2, {'before': false, 'after': true}],
    'max-len': [
      1,
      {
        code: 100,
        ignoreComments: true
      }
    ],
    'comma-dangle': ['error', 'always-multiline'],
    'one-var-declaration-per-line': ['error', 'initializations']
  },
  globals: {
    require: false,
    console: false,
    module: false,
    __dirname: false
  },
  env: {
    node: true,
    mocha: true,
    es6: true,
    jest: true
  },
  plugins: ['chai-friendly']
};
