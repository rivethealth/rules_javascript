// https://github.com/webpack/webpack-cli/issues/3044

Object.defineProperty(process.versions, "pnp", {
  get() {
    // eslint-disable-next-line unicorn/error-message
    if (new Error().stack!.includes("checkPackageExists")) {
      return "bazel";
    }
    // eslint-disable-next-line getter-return
    return;
  },
});
