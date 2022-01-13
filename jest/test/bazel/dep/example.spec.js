const { add } = require("@better-rules-javascript-test/jest-other/example");

test("adds numbers", () => {
  expect(add(1, 2)).toBe(3);
});
