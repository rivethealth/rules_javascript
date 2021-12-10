// https://github.com/webpack/webpack-cli/issues/3044

Object.defineProperty(process.versions, "pnp", {
  get() {
    if (new Error().stack.includes("checkPackageExists")) {
      return "bazel";
    }
  },
});
