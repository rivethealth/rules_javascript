NODE_MODULES_PREFIX = "_nodejs/node_modules"

def package_path_name(id):
    return id.replace("@", "").replace(":", "_").replace("/", "_")

def node_modules_links(packages, files):
    result = {}
    packages_dict = {package.short_path: package for package in packages}
    for file in files:
        parts = file.short_path.split("/")
        found = False
        for i in range(1, len(parts)):
            root = "/".join(parts[:i])
            if root in packages_dict:
                package = packages_dict[root]
                path = "%s/%s/%s" % (NODE_MODULES_PREFIX, package_path_name(package.id), "/".join(parts[i:]))
                result[path] = file
                found = True
                break
        if not found:
            fail("No packages found for file %s" % file.short_path)
    return result
