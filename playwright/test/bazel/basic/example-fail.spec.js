import { expect, test } from "@playwright/test";
import { add } from "./example.js";

test("adds numbers", () => {
  expect(add(1, 1)).toBe(3);
});
