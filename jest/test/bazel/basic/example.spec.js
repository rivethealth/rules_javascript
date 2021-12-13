const { add } = require("./example");

test("adds numbers", () => {
  expect(add(1, 2)).toBe(3);
});
