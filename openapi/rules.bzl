def _openapi_ts_impl(ctx):
    actions = ctx.actions
    name = ctx.attr.name
    openapi_typescript = ctx.executable._openapi_typescript
    openapi_typescript_default = ctx.attr._openapi_typescript[DefaultInfo]
    options = ctx.attr.options
    output = ctx.outputs.output
    src = ctx.file.src

    if not output:
        output = actions.declare_file("%s.d.ts" % name)

    args = actions.args()
    args.add("-o", output)
    for option in options:
        args.add(option)
    args.add(src)
    actions.run(
        arguments = [args],
        executable = openapi_typescript,
        mnemonic = "OpenapiTypescript",
        inputs = [src],
        outputs = [output],
        progress_message = "Generating %{label} OpenAPI TypeScript",
    )

    default_info = DefaultInfo(files = depset([output]))

    return [default_info]

openapi_ts = rule(
    attrs = {
        "options": attr.string_list(default = ["--alphabetize"], doc = "Openapi-typescript options"),
        "output": attr.output(doc = "TypeScript output"),
        "src": attr.label(
            allow_single_file = [".json", ".yml", ".yaml"],
            doc = "OpenAPI spec",
            mandatory = True,
        ),
        "_openapi_typescript": attr.label(
            default = ":openapi_typescript",
            cfg = "exec",
            executable = True,
        ),
    },
    implementation = _openapi_ts_impl,
)
