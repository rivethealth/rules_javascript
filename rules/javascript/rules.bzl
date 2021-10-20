load("//rules/commonjs:providers.bzl", "CjsInfo", "create_entry", "create_entry_set", "create_extra_link")
load("//rules/util:path.bzl", "runfile_path")
load(":providers.bzl", "JsInfo")

def _js_import_impl(ctx):
    js_info = ctx.attr.dep[JsInfo]
    return [js_info]

js_import = rule(
    attrs = {
        "dep": attr.label(
            mandatory = True,
            providers = [JsInfo],
        )
    },
    doc = "JavaScript import",
    implementation = _js_import_impl
)

def _js_library_impl(ctx):
    cjs_info = ctx.attr.root[CjsInfo]
    strip_prefix = ctx.attr.strip_prefix or cjs_info.prefix

    entries = []
    for src in ctx.files.srcs:
        path = runfile_path(ctx, src)
        if strip_prefix:
            if not path.startswith(strip_prefix + "/"):
                fail("Source %s does not have prefix %s" % (path, strip_prefix))
            path = path[len(strip_prefix + "/"):]
        if ctx.attr.prefix:
            path = ctx.attr.prefix + "/" + path
        entries.append(create_entry(label = ctx.label, name = path, file = src, root = cjs_info.root.id))

    js_deps = [dep[JsInfo] for dep in ctx.attr.deps]

    transitive_descriptors = depset(
        [cjs_info.descriptor],
        transitive = [js_info.transitive_descriptors for js_info in js_deps]
    )
    transitive_extra_links = depset(
        [
            create_extra_link(root = cjs_info.id, dep = dep[JsInfo].root, label = dep.label)
            for dep in ctx.attr.deps
        ],
        transitive = [js_info.transitive_extra_links for js_info in js_deps]
    )
    transitive_roots = depset(
        [cjs_info.root],
        transitive = [js_info.transitive_roots for js_info in js_deps]
    )
    js_entry_set = create_entry_set(
        entries = entries,
        entry_sets = [js_info.js_entry_set for js_info in js_deps]
    )
    src_entry_set = create_entry_set(
        entry_sets = [js_info.src_entry_set for js_info in js_deps]
    )

    js_info = JsInfo(
        js_entry_set = js_entry_set,
        root = cjs_info.id,
        src_entry_set = src_entry_set,
        transitive_descriptors = transitive_descriptors,
        transitive_extra_links = transitive_extra_links,
        transitive_roots = transitive_roots,
    )

    return [js_info]

js_library = rule(
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies.",
            providers = [JsInfo],
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
            doc = "Remove prefix. Defaults to root prefix.",
        ),
    },
    doc = "JavaScript library",
    implementation = _js_library_impl,
)
