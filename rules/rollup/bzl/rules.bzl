load("//rules/javascript/bzl:providers.bzl", "JsInfo", "create_js", "create_package", "create_package_dep")
load("//rules/javascript/bzl:rules.bzl", "default_package_name")
load("//rules/nodejs/bzl:rules.bzl", "write_packages_manifest")
load(":providers.bzl", "RollupInfo")

def _rollup_impl(ctx):
    rollup = ctx.attr.dep[JsInfo]
    plugins = [ctx.attr._resolve_plugin[JsInfo]] + [dep[JsInfo] for dep in ctx.attr.plugins]
    package_deps = [create_package_dep("rollup", id) for id in rollup.ids]
    package = create_package("", "", deps = tuple(package_deps))
    js_info = create_js(
        package,
        global_package_ids = [id for dep in plugins for id in dep.ids],
        deps = [rollup] + plugins,
    )

    manifest = ctx.actions.declare_file("%s/packages-manifest.txt" % ctx.label.name)
    write_packages_manifest(ctx, manifest, js_info)

    plugins = {dep.name: None for dep in plugins}

    rollup_info = RollupInfo(
        dep = js_info,
        manifest = manifest,
        plugins = plugins,
    )

    return [rollup_info]

rollup = rule(
    attrs = {
        "dep": attr.label(
            mandatory = True,
            providers = [JsInfo],
        ),
        "plugins": attr.label_list(providers = [JsInfo]),
        "_resolve_plugin": attr.label(
            default = "//rules/rollup:resolve",
            providers = [JsInfo],
        ),
    },
    implementation = _rollup_impl,
)

def _rollup_bundle_impl(ctx):
    rollup = ctx.attr.rollup[RollupInfo]
    dep = ctx.attr.dep[JsInfo]

    main = "_main"
    if ctx.attr.main:
        main = "%s/%s" % (main, ctx.attr.main)

    package_deps = [create_package_dep("_main", id) for id in dep.ids]
    package = create_package("", "", deps = tuple(package_deps))
    js_info = create_js(package, deps = [dep])

    manifest = ctx.actions.declare_file("%s/packages-manifest.txt" % ctx.label.name)
    write_packages_manifest(ctx, manifest, js_info)

    output = ctx.actions.declare_file("%s/bundle.js" % ctx.label.name)

    args = ctx.actions.args()
    args.add(rollup.manifest.path)
    args.add("rollup/dist/bin/rollup")
    args.add("-i", main)
    args.add("-o", output.path)
    args.add("--silent")

    for name, arg in rollup.plugins.items():
        if name == "@better_rules_javascript/rules/rollup":
            arg = struct(manifest = manifest.path).to_json()
        if arg != None:
            args.add("-p", "%s=%s" % (name, arg))
        else:
            args.add("-p", name)

    ctx.actions.run(
        executable = ctx.executable._runner,
        arguments = [args],
        inputs = depset([rollup.manifest, manifest], transitive = [rollup.dep.transitive_files, js_info.transitive_files]),
        outputs = [output],
    )

    default_info = DefaultInfo(files = depset([output]))

    return [default_info]

rollup_bundle = rule(
    attrs = {
        "dep": attr.label(providers = [JsInfo]),
        "main": attr.string(),
        "rollup": attr.label(
            default = "//external:rollup",
            providers = [RollupInfo],
        ),
        "_runner": attr.label(
            doc = "Node.js runner",
            executable = True,
            cfg = "host",
            default = "//rules/nodejs:bin",
        ),
    },
    implementation = _rollup_bundle_impl,
    outputs = {"bundle": "%{name}/bundle.js"},
)
