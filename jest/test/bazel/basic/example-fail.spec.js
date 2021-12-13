const { add } = require("./example");

test("adds numbers", () => {
  expect(add(1, 1)).toBe(3);
});
