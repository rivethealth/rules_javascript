def _js_import_external_impl(ctx):
    ctx.download_and_extract(
        ctx.attr.urls,
        "npm",
        ctx.attr.sha256,
        stripPrefix = "package",
    )

    json = ctx.read("npm/package.json")

    ctx.template("BUILD.bazel", ctx.attr._template)

js_import_external = rule(
    implementation = _js_import_external_impl,
    attrs = {
        "package": attr.label(
            allow_single_file = ".json",
            doc = "package.json",
        ),
        "src": attr.label(
        ),
        "sha256": attr.string(
            doc = "SHA256 digest",
        ),
        "src": attr.label(
            allow_single_file = True,
            default = "@better_rules_javascript//rules/npm:BUILD.bazel.tpl",
        ),
    },
)
