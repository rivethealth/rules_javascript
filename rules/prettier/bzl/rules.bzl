load("//rules/nodejs/bzl:rules.bzl", "write_packages_manifest")
load("//rules/javascript/bzl:providers.bzl", "JsInfo", "add_globals", "merge_js")
load("//rules/nodejs/bzl:rules.bzl", "create_nodejs_binary")
load(":providers.bzl", "PrettierInfo")

def _prettier_impl(ctx):
    prettier = ctx.attr.prettier[JsInfo]
    dep = ctx.attr._dep[JsInfo]
    dep = merge_js(dep, [prettier])
    dep = add_globals(dep, [prettier.id])

    packages_manifest = ctx.actions.declare_file("%s/packages-manifest.txt" % ctx.label.name)
    write_packages_manifest(ctx, packages_manifest, dep)

    prettier_info = PrettierInfo(
        config = ctx.file.config,
        dep = dep,
        manifest = packages_manifest,
        plugins = [plugin[JsInfo] for plugin in ctx.attr.plugins],
    )

    return [prettier_info]

prettier = rule(
    implementation = _prettier_impl,
    attrs = {
        "config": attr.label(
            doc = "Configuration file",
            allow_single_file = True,
        ),
        "prettier": attr.label(
            doc = "Prettier library",
            mandatory = True,
        ),
        "plugins": attr.label_list(
            doc = "Plugins to load",
            providers = [JsInfo],
        ),
        "_dep": attr.label(
            doc = "Main JS",
            default = "//rules/prettier:js",
            providers = [JsInfo],
        ),
    },
)

def _prettier_format_impl(ctx):
    prettier_info = ctx.attr.prettier[PrettierInfo]

    script = ""

    outputs = []

    for file in ctx.files.srcs:
        inputs = []
        args = ctx.actions.args()

        formatted = ctx.actions.declare_file("_format/src/%s" % file.path)
        outputs.append(formatted)
        script += "format %s %s \n" % (file.path, formatted.path)

        args.add(prettier_info.manifest.path)
        args.add(prettier_info.dep.id)
        inputs.append(prettier_info.manifest)

        args.add(prettier_info.dep.name)

        if prettier_info.config:
            args.add("--config", prettier_info.config.path)
            inputs.append(prettier_info.config)

        args.add(file.path)
        inputs.append(file)

        args.add(formatted.path)
        outputs.append(formatted)

        ctx.actions.run(
            executable = ctx.attr._runner.files_to_run,
            arguments = [args],
            inputs = depset(inputs, transitive = [prettier_info.dep.transitive_files]),
            outputs = [formatted],
        )

    bin = ctx.actions.declare_file("_format/bin")
    ctx.actions.expand_template(
        template = ctx.file._write,
        output = bin,
        substitutions = {"%{files}": script},
    )

    default_info = DefaultInfo(files = depset(outputs + [bin]))

    return [default_info]

prettier_format = rule(
    implementation = _prettier_format_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = True,
            mandatory = True,
        ),
        "prettier": attr.label(
            default = "//external:prettier",
            providers = [PrettierInfo],
        ),
        "_runner": attr.label(
            doc = "Node.js runner",
            executable = True,
            cfg = "host",
            default = "//rules/nodejs:bin",
        ),
        "_write": attr.label(
            default = "@better_rules_javascript//rules/prettier:runner.sh.tpl",
            allow_single_file = True,
        ),
    },
)
