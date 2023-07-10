load("@bazel_skylib//lib:paths.bzl", "paths")
load("@rules_file//util:path.bzl", output_name_impl = "output_name")

def link_file(file, actions, label, output, strip_prefix = "", prefix = ""):
    path = output_name(
        file = file,
        label = label,
        strip_prefix = strip_prefix,
        prefix = prefix,
    )
    if file.path == "%s/%s" % (output.path, path):
        return file
    result = actions.declare_file(path)
    actions.symlink(
        target_file = file,
        output = result,
    )
    return result

def nearest(ancestors, path):
    parts = path.split("/")
    for i in range(len(parts), -1, -1):
        ancestor = "/".join(parts[:i])
        if ancestor in ancestors:
            return ancestor

def relativize(path, start):
    if not start:
        return path

    path_parts = path.split("/")
    start_parts = start.split("/")

    result_parts = []
    match = True
    for i, part in enumerate(path_parts):
        if match:
            match = i < len(start_parts) and part == start_parts[i]
            if not match:
                result_parts = [".."] * (len(start_parts) - i)
        if not match:
            result_parts.append(part)

    if not result_parts:
        result_parts = [".."] * (len(start_parts) - len(path_parts))
    if not result_parts:
        result_parts = ["."]

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

output_name = output_name_impl
