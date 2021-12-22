load("//util:path.bzl", "output", "runfile_path")

CjsDescriptorInfo = provider(
    fields = {
        "descriptors": "List of files",
        "path": "Root path",
    },
)

# see http://wiki.commonjs.org/wiki/Packages/1.0
CjsInfo = provider(
    doc = "CommonJS-style package",
    fields = {
        "descriptors": "Descriptor files",
        "package": "Package struct",
        "name": "Name",
    },
)

CjsEntries = provider(
    doc = "CommonJS entries",
    fields = {
        "name": "Name",
        "package": "Package",
        "transitive_packages": "Packages",
        "transitive_deps": "Deps",
        "transitive_files": "Files",
    },
)

def create_package(id, path, short_path, label):
    """Create package struct.

    Args:
        id: ID
        path: Part to directory
        short_path: Short path to directory
        descriptors: List of package descriptors
        label: Source label
    """
    return struct(
        id = id,
        label = label,
        path = path,
        short_path = short_path,
    )

def create_dep(id, name, dep, label):
    """Create link for CommonJs package.

    Args:
        id: Package ID
        name: Name
        dep: Dependency package ID
        label: Source label
    """
    return struct(
        dep = dep,
        id = id,
        label = label,
        name = name,
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

def create_global(id, name):
    return struct(
        id = id,
        name = name,
    )

def _dep_arg(dep):
    data = struct(
        id = dep.id,
        dep = dep.dep,
        label = str(dep.label),
        name = dep.name,
    )
    return json.encode(data)

def _global_arg(dep):
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

def default_strip_prefix(ctx):
    workspace = ctx.label.workspace_name or ctx.workspace_name
    parts = [workspace]
    if ctx.label.package:
        parts.append(ctx.label.package)
    return "/".join(parts)

def gen_manifest(actions, manifest_bin, manifest, packages, deps, globals, package_path):
    def package_arg(package):
        return _package_arg(package, package_path)

    args = actions.args()
    args.add_all(packages, before_each = "--package", map_each = package_arg, allow_closure = True)
    args.add_all(deps, before_each = "--dep", map_each = _dep_arg)
    args.add_all(globals, before_each = "--global", map_each = _global_arg)
    args.add(manifest)
    actions.run(
        arguments = [args],
        executable = manifest_bin.files_to_run.executable,
        outputs = [manifest],
        mnemonic = "GenManifest",
        progress_message = "Generating package manifest %{output}",
        tools = [manifest_bin.files_to_run],
    )

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

def package_path(package):
    return package.path
