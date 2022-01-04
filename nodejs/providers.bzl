NODE_MODULES_PREFIX = "_nodejs/node_modules"

def package_path_name(id):
    return id.replace("@", "").replace(":", "_").replace("/", "_")

def modules_links(prefix, packages, files):
    result = {}

    packages_dict = {package.short_path: package for package in packages}
    for file in files:
        parts = file.short_path.split("/")
        found = False

        # find longest prefix
        for i in reversed(range(len(parts))):
            root = "/".join(parts[:i])
            package = packages_dict.get(root, None)
            if package != None:
                path = "%s/%s/%s" % (prefix, package_path_name(package.id), "/".join(parts[i:]))
                result[path] = file
                found = True
                break
        if not found:
            fail("No packages found for file %s" % file.short_path)

    return result
