load("//util:path.bzl", "output", "runfile_path")

# see http://wiki.commonjs.org/wiki/Packages/1.0
CjsInfo = provider(
    doc = "CommonJS-style package info",
    fields = {
        "name": "Name",
        "package": "Package",
        "transitive_files": "Files",
        "transitive_packages": "Packages",
        "transitive_links": "Links",
    },
)

def create_package(name, path, short_path, label):
    """Create CommonJs package definition.

    Args:
        name: Name
        path: Path of root directory
        short_path: Short path of root directory
        label: Source label
    """
    return struct(
        name = name,
        label = label,
        path = path,
        short_path = short_path,
    )

def create_link(path, name, dep, label):
    """Create link for CommonJs package.

    Args:
        path: Package path
        name: Name
        label: Source label
        dep: Dependency package path
    """
    return struct(
        path = path,
        dep = dep,
        label = label,
        name = name,
    )

def _dep_arg(dep):
    data = struct(
        dep = dep.dep,
        id = dep.path,
        label = str(dep.label),
        name = dep.name,
    )
    return json.encode(data)

def _package_arg(package, package_path):
    data = struct(
        id = package.path,
        label = str(package.label),
        name = package.name,
        path = package_path(package),
    )
    return json.encode(data)

def gen_manifest(actions, manifest_bin, manifest, packages, deps, package_path):
    """Create package manifest.

    Args:
        actions: Actions struct
        manifest_bin: Manfiest generation executable
        manifest: Manifest output
        packages: Depset of packages
        deps: Depset of dependencies
        package_path: Function for package path
    """

    def package_arg(package):
        return _package_arg(package, package_path)

    args = actions.args()
    args.add_all(deps, before_each = "--dep", map_each = _dep_arg)
    args.add_all(packages, before_each = "--package", map_each = package_arg, allow_closure = True)
    args.add(manifest)
    actions.run(
        arguments = [args],
        executable = manifest_bin.files_to_run.executable,
        outputs = [manifest],
        mnemonic = "GenCjsManifest",
        progress_message = "Generating package manifest %{output}",
        tools = [manifest_bin.files_to_run],
    )

def _output_name(root, package_output, prefix):
    path = prefix

def package_path(package):
    return package.path

def cjs_npm_label(repo):
    return "@%s//:root" % repo

def create_links(package, label, cjs_infos):
    """Create deps.

    Args:
        package: Package struct
        label: Source label
        cjs_infos: CjsInfo
    """
    return [
        create_link(path = package.path, name = cjs_info.name, dep = cjs_info.package.path, label = label)
        for cjs_info in cjs_infos
    ]

def create_globals(label, cjs_infos):
    """Create globals.

    Args:
        label: Source label
        cjs_infos: CjsInfo
    """
    return [
        create_link(path = None, dep = cjs_info.package.path, name = cjs_info.name, label = label)
        for cjs_info in cjs_infos
    ]

def create_extra_deps(package, label, extra_deps):
    return [
        create_link(
            dep = path,
            path = package.path,
            label = label,
            name = name,
        )
        for name, path in extra_deps.items()
    ]

def create_cjs_info(cjs_root, label, files = [], deps = [], globals = []):
    return CjsInfo(
        package = cjs_root.package,
        name = cjs_root.name,
        transitive_files = depset(
            files,
            transitive = [cjs_info.transitive_files for cjs_info in [cjs_root] + deps + globals],
        ),
        transitive_links = depset(
            create_links(cjs_root.package, label, deps) + create_globals(label, globals),
            transitive = [cjs_info.transitive_links for cjs_info in deps + globals],
        ),
        transitive_packages = depset(
            [cjs_root.package],
            transitive = [cjs_info.transitive_packages for cjs_info in deps + globals],
        ),
    )
