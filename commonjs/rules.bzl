load("//util:path.bzl", "output", "runfile_path")
load(":providers.bzl", "CjsInfo", "create_package")

def _dep_arg(dep):
    data = struct(
        id = dep.id,
        dep = dep.dep,
        label = str(dep.label),
        name = dep.name,
    )
    return json.encode(data)

def _global(dep):
    data = struct(
        id = dep.id,
        name = dep.name,
    )
    return json.encode(data)

def _package_arg(package, package_path):
    data = struct(
        id = package.id,
        path = package_path(package),
        label = str(package.label),
    )
    return json.encode(data)

def package_path(package):
    return package.path

def gen_manifest(actions, manifest_bin, manifest, packages, deps, globals, package_path):
    def package_arg(package):
        return _package_arg(package, package_path)

    args = actions.args()
    args.add_all(packages, before_each = "--package", map_each = package_arg, allow_closure = True)
    args.add_all(deps, before_each = "--dep", map_each = _dep_arg)
    args.add_all(globals, before_each = "--global", map_each = _global)
    args.add(manifest)
    actions.run(
        arguments = [args],
        executable = manifest_bin.files_to_run.executable,
        outputs = [manifest],
        mnemonic = "GenManifest",
        progress_message = "Generating package manifest %{output}",
        tools = [manifest_bin.files_to_run],
    )

def create_entries(ctx, actions, srcs, prefix, strip_prefix):
    files = []
    for src in srcs:
        path = runfile_path(ctx.workspace_name, src)
        if path == strip_prefix:
            path = prefix
        else:
            if strip_prefix:
                if not path.startswith(strip_prefix + "/"):
                    fail("Source %s does not have prefix %s" % (path, strip_prefix))
                path = path[len(strip_prefix + "/"):]
            if prefix:
                path = prefix + "/" + path
        file = actions.declare_file(path)
        actions.symlink(
            output = file,
            target_file = src,
            progress_message = "Copying file to %{output}",
        )
        files.append(file)
    return files

def _default_package_name(ctx):
    workspace = "@%s" % (ctx.label.workspace_name or ctx.workspace_name)
    parts = [workspace]
    if ctx.label.package:
        parts.append(ctx.label.package)
    return "/".join(parts)

def default_strip_prefix(ctx):
    workspace = ctx.label.workspace_name or ctx.workspace_name
    parts = [workspace]
    if ctx.label.package:
        parts.append(ctx.label.package)
    return "/".join(parts)

def output_prefix(path, label, actions):
    dummy = actions.declare_file("%s.package" % label.name)
    actions.write(dummy, "")

    if path == dummy.dirname:
        return ""
    if dummy.dirname.startswith(path + "/"):
        return ""
    if path.startswith(dummy.dirname + "/"):
        return path[len(dummy.dirname + "/"):]
    fail("Package %s not compatible with ouput %s" % (path, dummy.dirname))

def _cjs_descriptors_impl_(ctx):
    fail("TODO")

cjs_descriptors = rule(
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".json"],
            mandatory = True,
        ),
        "prefix": attr.string(),
        "strip_prefix": attr.string(),
    },
    implementation = _cjs_descriptors_impl_,
)

def _cjs_root_impl(ctx):
    name = ctx.attr.package_name or _default_package_name(ctx)
    prefix = ctx.label.name if not ctx.attr.subpackages else ""
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    output_ = output(ctx.label, ctx.actions)

    path = output_.path
    short_path = output_.short_path
    if not ctx.attr.subpackages:
        prefix = ctx.label.name
        path = "%s/%s" % (path, ctx.label.name) if path else ctx.label.name
        short_path = "%s/%s" % (short_path, ctx.label.name) if short_path else ctx.label.name
    else:
        prefix = ""

    descriptors = create_entries(ctx, ctx.actions, ctx.files.descriptors, prefix, strip_prefix)

    package = create_package(
        id = str(ctx.label),
        label = ctx.label,
        path = path,
        short_path = short_path,
    )
    cjs_info = CjsInfo(
        descriptors = descriptors,
        package = package,
        name = name,
    )

    return [cjs_info]

cjs_root = rule(
    doc = "CommonJS-style root",
    implementation = _cjs_root_impl,
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies",
        ),
        "descriptors": attr.label_list(
            allow_files = [".json"],
            doc = "package.json descriptors",
        ),
        "package_name": attr.string(
            doc = "Package name",
            mandatory = True,
        ),
        "subpackages": attr.bool(
            doc = "Whether to allow Bazel subpackages",
        ),
        "strip_prefix": attr.string(),
    },
)
