load("//commonjs:providers.bzl", "CjsInfo", "create_dep")
load("//commonjs:rules.bzl", "create_entries", "default_strip_prefix", "output_prefix")
load("//util:path.bzl", "runfile_path")
load(":providers.bzl", "JsInfo")

def _js_import_impl(ctx):
    js_info = ctx.attr.dep[JsInfo]

    js_info = JsInfo(
        name = ctx.attr.package_name or js_info.name,
        package = js_info.package,
        transitive_deps = js_info.transitive_deps,
        transitive_descriptors = js_info.transitive_descriptors,
        transitive_js = js_info.transitive_js,
        transitive_packages = js_info.transitive_packages,
        transitive_srcs = js_info.transitive_srcs,
    )

    return [js_info]

js_import = rule(
    attrs = {
        "dep": attr.label(
            mandatory = True,
            providers = [JsInfo],
        ),
        "package_name": attr.string(
            doc = "Package alias",
        ),
    },
    doc = "JavaScript import",
    implementation = _js_import_impl,
)

def _js_library_impl(ctx):
    cjs_info = ctx.attr.root[CjsInfo]
    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    if ctx.attr.prefix:
        prefix = "%s/%s" % (prefix, ctx.attr.prefix)

    js = create_entries(
        ctx = ctx,
        actions = ctx.actions,
        srcs = ctx.files.srcs,
        strip_prefix = strip_prefix,
        prefix = prefix,
    )

    js_deps = [dep[JsInfo] for dep in ctx.attr.deps]

    transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [js_info.transitive_descriptors for js_info in js_deps],
    )
    transitive_deps = depset(
        [
            create_dep(
                dep = dep[JsInfo].package.id,
                id = cjs_info.package.id,
                label = dep.label,
                name = dep[JsInfo].name,
            )
            for dep in ctx.attr.deps
        ] + [
            create_dep(
                dep = id,
                id = cjs_info.package.id,
                label = Label(id),
                name = name,
            )
            for name, id in ctx.attr.extra_deps.items()
        ],
        transitive = [js_info.transitive_deps for js_info in js_deps],
    )
    transitive_packages = depset(
        [cjs_info.package],
        transitive = [js_info.transitive_packages for js_info in js_deps],
    )
    transitive_js = depset(
        js,
        transitive = [js_info.transitive_js for js_info in js_deps],
    )
    transitive_srcs = depset(
        [],
        transitive = [js_info.transitive_srcs for js_info in js_deps],
    )

    js_info = JsInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_descriptors = transitive_descriptors,
        transitive_deps = transitive_deps,
        transitive_packages = transitive_packages,
        transitive_js = transitive_js,
        transitive_srcs = transitive_srcs,
    )

    return [js_info]

js_library = rule(
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies.",
            providers = [JsInfo],
        ),
        "extra_deps": attr.string_dict(
            doc = "Extra dependencies.",
        ),
        "prefix": attr.string(
            doc = "Prefix to add. Defaults to empty.",
        ),
        "root": attr.label(
            mandatory = True,
            providers = [CjsInfo],
        ),
        "srcs": attr.label_list(
            allow_files = True,
            doc = "JavaScript files and data.",
            mandatory = True,
        ),
        "strip_prefix": attr.string(
            doc = "Remove prefix. Defaults to empty.",
        ),
    },
    doc = "JavaScript library",
    implementation = _js_library_impl,
)
