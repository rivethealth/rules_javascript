load("//util:path.bzl", "runfile_path")

NodejsRuntimeInfo = provider(
    doc = "Node.js runtime.",
    fields = {
        "bin": "Node.js executable",
    },
)

NodejsInfo = provider(
    doc = "Node.js executable information.",
    fields = {
        "bin": "Node.js executable",
        "options": "Node.js options",
    },
)

NODE_MODULES_PREFIX = "_nodejs/node_modules"

def package_path_name(workspace_name, short_path):
    path = runfile_path(workspace_name, struct(short_path = short_path))
    parts = path.split("/", 1)
    repo = parts[0]
    package = parts[1].replace("/", "_") if 1 < len(parts) else ""
    return "@%s/_%s" % (repo, package)

def modules_links(workspace_name, prefix, packages, files):
    result = {}

    packages_dict = {package.short_path: package for package in packages}
    for file in files:
        parts = file.short_path.split("/")
        found = False

        # find longest prefix
        for i in reversed(range(len(parts) + 1)):
            root = "/".join(parts[:i])
            package = packages_dict.get(root, None)
            if package != None:
                package_root = package_path_name(workspace_name, package.short_path)
                path = "%s/%s" % (prefix, "/".join([package_root] + parts[i:]))
                result[path] = file
                found = True
                break
        if not found:
            result[runfile_path(workspace_name, file)] = file

    return result

def nodejs_runtime_rule(name):
    def nodejs_runtime_impl(ctx):
        nodejs_toolchain = ctx.toolchains["%s.toolchain_type" % name]

        nodejs_runtime_info = NodejsRuntimeInfo(bin = nodejs_toolchain.bin)

        return [nodejs_runtime_info]

    nodejs_runtime = rule(
        implementation = nodejs_runtime_impl,
        provides = [NodejsRuntimeInfo],
        toolchains = ["%s.toolchain_type" % name],
    )

    return nodejs_runtime
