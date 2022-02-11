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

def package_path(package):
    return package.path

def cjs_npm_label(repo):
    return "@%s//:root" % repo
