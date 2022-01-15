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

def create_package(id, name, path, short_path, label):
    """Create package struct.

    Args:
        id: ID
        name: Name of package
        path: Part to directory
        short_path: Short path to directory
        descriptors: List of package descriptors
        label: Source label
    """
    return struct(
        id = id,
        name = name,
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
        name = package.name,
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

def _output_name(root, package_output, prefix):
    path = prefix

def output_root(root, package_output, prefix):
    if root.path.startswith(package_output.path + "/"):
        return "%s/%s" % (root.path, prefix) if prefix else root.path
    elif root.path != package_output.path:
        fail("Output %s cannot write to %s" % (package_output.path, root))
    return root.path

def output_name(workspace_name, file, root, package_output, prefix, strip_prefix):
    """
    Computes the output name for a file.

    Args:
      workspace_name: Workspace name
      file: Source file
      root: Output root
      package_output: Bazel package output path
      prefix: Path segments to prepend
      strip_prefix: Path segments to remove
    """
    path = runfile_path(workspace_name, file)
    if strip_prefix:
        if path == strip_prefix:
            path = ""
        elif path.startswith(strip_prefix + "/"):
            path = path[len(strip_prefix + "/"):]
        else:
            fail("File %s does not have prefix %s" % (path, strip_prefix))
    if prefix:
        path = "%s/%s" % (prefix, path) if path else prefix
    if root.path.startswith(package_output.path + "/"):
        output = root.path[len(package_output.path + "/"):]
        path = "%s/%s" % (output, path) if path else output
    elif root.path != package_output.path:
        fail("Output %s cannot write to %s" % (package_output.path, root.path))
    return path

def package_path(package):
    return package.path

def cjs_npm_label(repo):
    return "@%s//:root" % repo
