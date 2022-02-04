load("@bazel_skylib//lib:paths.bzl", "paths")

def relativize(path, start):
    path_parts = path.split("/")
    start_parts = path.split("/")

    result_parts = []
    match = True
    for i in len(path_parts):
        if match:
            match = i < len(start_parts) and path_parts[i] == start_parts[i]
            if not match:
                result_parts = result_parts + [".."] * (len(start_parts) - i - 1)
        else:
            result_parts.append(match)

    return "/".join(result_parts)

def runfile_path(workspace, file):
    path = file.short_path
    if path.startswith("../"):
        path = path[len("../"):]
    else:
        path = "%s/%s" % (workspace, path)
    return path

def output(label, actions, dir = ""):
    """
    Returns the output paths
    """
    if dir:
        base = ".dummy"
        name = "%s/%s" % (dir, base)
    else:
        base = "%s.dummy" % label.name
        name = base
    file = actions.declare_file(name)
    actions.write(file, "")
    return struct(
        path = file.path[:-len("/" + base)],
        short_path = file.short_path[:-len("/" + base)],
    )

def output_name(label, file, strip_prefix = "", prefix = ""):
    path = file.short_path
    if path.startswith("../"):
        path = "/".join(path.split("/")[2:])
    if strip_prefix.startswith("/"):
        strip_prefix = strip_prefix[len("/"):]
    elif label.package:
        strip_prefix = "%s/%s" % (label.package, strip_prefix) if strip_prefix else label.package

    if not strip_prefix:
        pass
    elif path == strip_prefix:
        path = ""
    elif path.startswith(strip_prefix + "/"):
        path = path[len(strip_prefix + "/"):]
    else:
        fail("File %s does not have prefix %s" % (path, strip_prefix))

    if prefix:
        path = "%s/%s" % (prefix, path) if path else prefix
    return path
