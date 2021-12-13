const { add } = require("@better_rules_javascript_test/jest-other/example");

test("adds numbers", () => {
  expect(add(1, 2)).toBe(3);
});
