load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")
load("//commonjs:providers.bzl", "CjsInfo", "create_cjs_info")
load("//util:path.bzl", "output", "output_name")
load(":providers.bzl", "JsInfo", "create_js_info")

def _js_library_impl(ctx):
    actions = ctx.actions
    cjs_root = ctx.attr.root and ctx.attr.root[CjsInfo]
    cjs_deps = [dep[CjsInfo] for dep in ctx.attr.deps if CjsInfo in dep]
    cjs_globals = [dep[CjsInfo] for dep in ctx.attr.global_deps]
    js_deps = [dep[JsInfo] for dep in ctx.attr.deps + ctx.attr.global_deps if str(dep.label) not in ctx.attr._system_lib[BuildSettingInfo].value]
    default_deps = [target[DefaultInfo] for target in ctx.attr.deps + ctx.attr.data]
    output_ = output(label = ctx.label, actions = actions)
    prefix = ctx.attr.prefix
    strip_prefix = ctx.attr.strip_prefix
    label = ctx.label

    js = []
    for file in ctx.files.srcs:
        path = output_name(
            file = file,
            label = label,
            prefix = prefix,
            strip_prefix = strip_prefix,
        )
        if file.path == "%s/%s" % (output_.path, path):
            js_ = file
        else:
            js_ = actions.declare_file(path)
            actions.symlink(
                target_file = file,
                output = js_,
            )
        js.append(js_)

    cjs_info = cjs_root and create_cjs_info(
        cjs_root = cjs_root,
        deps = cjs_deps,
        globals = cjs_globals,
        label = label,
    )

    js_info = create_js_info(
        files = js,
        cjs_root = cjs_root,
        deps = js_deps,
    )

    runfiles = ctx.runfiles()
    runfiles = runfiles.merge_all([default_info.default_runfiles for default_info in default_deps])
    default_info = DefaultInfo(files = depset(js), runfiles = runfiles)

    return [default_info, js_info] + ([cjs_info] if cjs_info else [])

js_library = rule(
    attrs = {
        "data": attr.label_list(
            allow_files = True,
            doc = "Runfile files. These are added to normal runfiles tree, not CommonJS packages.",
        ),
        "deps": attr.label_list(
            doc = "Dependencies.",
            providers = [JsInfo],
        ),
        "global_deps": attr.label_list(
            doc = "Global dependencies.",
            providers = [CjsInfo, JsInfo],
        ),
        "prefix": attr.string(
            doc = "Prefix to add.",
        ),
        "root": attr.label(
            providers = [CjsInfo],
        ),
        "srcs": attr.label_list(
            allow_files = True,
            doc = "JavaScript files and data.",
        ),
        "strip_prefix": attr.string(
            doc = "Package-relative prefix to remove.",
        ),
        "_system_lib": attr.label(
            default = "//javascript:system_lib",
            providers = [BuildSettingInfo],
        ),
    },
    doc = "JavaScript library",
    implementation = _js_library_impl,
    provides = [JsInfo],
)

def _js_export_impl(ctx):
    cjs_dep = ctx.attr.dep[CjsInfo]
    cjs_deps = [target[CjsInfo] for target in ctx.attr.deps]
    cjs_extra = [target[CjsInfo] for target in ctx.attr.extra_deps]
    cjs_globals = [target[CjsInfo] for target in ctx.attr.global_deps]
    default_dep = ctx.attr.dep[DefaultInfo]
    package_name = ctx.attr.package_name
    js_dep = ctx.attr.dep[JsInfo]
    js_deps = [target[JsInfo] for target in ctx.attr.global_deps + ctx.attr.deps + ctx.attr.extra_deps if str(target.label) not in ctx.attr._system_lib[BuildSettingInfo].value]
    label = ctx.label

    default_info = default_dep
    cjs_root = struct(
        name = package_name or cjs_dep.name,
        package = cjs_dep.package,
        transitive_files = depset(),
        transitive_links = depset(),
        transitive_packages = depset(),
    )
    cjs_info = create_cjs_info(
        cjs_root = cjs_root,
        deps = cjs_deps,
        globals = cjs_globals,
        label = label,
    )
    cjs_info = CjsInfo(
        name = cjs_info.name,
        transitive_files = depset(transitive = [c.transitive_files for c in [cjs_dep, cjs_info] + cjs_extra]),
        package = cjs_info.package,
        transitive_links = depset(transitive = [c.transitive_links for c in [cjs_dep, cjs_info] + cjs_extra]),
        transitive_packages = depset(transitive = [c.transitive_packages for c in [cjs_dep, cjs_info] + cjs_extra]),
    )

    js_info = create_js_info(
        cjs_root = cjs_root,
        deps = [js_dep] + js_deps,
    )

    return [cjs_info, default_info, js_info]

js_export = rule(
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies to add.",
            providers = [CjsInfo, JsInfo],
        ),
        "extra_deps": attr.label_list(
            doc = "Extra dependencies to add.",
            providers = [CjsInfo, JsInfo],
        ),
        "global_deps": attr.label_list(
            doc = "Global dependencies to add.",
            providers = [CjsInfo, JsInfo],
        ),
        "package_name": attr.string(
            doc = "Dependency name. Defaults to root's name.",
        ),
        "dep": attr.label(
            doc = "JavaScript library.",
            mandatory = True,
            providers = [CjsInfo, JsInfo],
        ),
        "_system_lib": attr.label(
            default = "//javascript:system_lib",
            providers = [BuildSettingInfo],
        ),
    },
    doc = "Add dependencies, or use alias.",
    implementation = _js_export_impl,
    provides = [CjsInfo, JsInfo],
)
