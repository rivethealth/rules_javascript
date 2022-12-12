module.exports = {
  root: true,
  plugins: ["@typescript-eslint", "unicorn"],
  extends: ["eslint:recommended", "plugin:unicorn/recommended"],
  overrides: [
    {
      files: ["**/*.ts"],
      extends: [
        "plugin:@typescript-eslint/eslint-recommended",
        "plugin:@typescript-eslint/recommended",
      ],
      parser: "@typescript-eslint/parser",
      rules: {
        // arrow functions cannot be generators
        "@typescript-eslint/no-this-alias": "off",
        // helpful for typing
        "@typescript-eslint/ban-ts-comment": "off",
        // too many exceptions
        "@typescript-eslint/ban-types": "off",
        // no-ops are legitimate
        "@typescript-eslint/no-empty-function": "off",
        // helpful for typing
        "@typescript-eslint/no-explicit-any": "off",
        // helpful for documentation
        "@typescript-eslint/no-inferrable-types": "off",
        // helpful for organization
        "@typescript-eslint/no-namespace": "off",
        // helpful for typing
        "@typescript-eslint/no-non-null-assertion": "off",
        "@typescript-eslint/no-var-requires": "off",
        "prefer-rest-params": "off",
        "prefer-spread": "off",
      },
    },
  ],
  rules: {
    // can be useful to have await inside Promise callback
    "no-async-promise-executor": "off",
    // https://github.com/typescript-eslint/typescript-eslint/issues/2818
    "no-redeclare": "off",
    // control characters (escaped) are legitimate in regexes
    "no-control-regex": "off",
    // only err if all variables can be constant
    "prefer-const": ["error", { destructuring: "all" }],
    // while(true) is legitimate
    "no-constant-condition": ["error", { checkLoops: false }],
    // catch {} is legitimate
    "no-empty": ["error", { allowEmptyCatch: true }],
    // legitimate inside TS namespaces
    "no-inner-declarations": "off",
    // prettier causes this
    "no-unexpected-multiline": "off",
    // https://github.com/typescript-eslint/typescript-eslint/issues/291
    "no-dupe-class-members": "off",
    "unicorn/no-array-callback-reference": "off",
    "unicorn/no-array-method-this-argument": "off",
    "unicorn/no-nested-ternary": "off",
    "unicorn/no-null": "off",
    "unicorn/no-process-exit": "off",
    "unicorn/prefer-module": "off",
    "unicorn/prefer-top-level-await": "off",
    "unicorn/prevent-abbreviations": "off",
  },
  env: { jest: true, node: true },
  globals: {
    gc: true,
    //https://github.com/Chatie/eslint-config/issues/45
    NodeJS: true,
  },
};
