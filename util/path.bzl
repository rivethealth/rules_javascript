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
    file = actions.declare_file("%s.dummy" % label.name if not dir else "%s/.dummy" % dir)
    actions.write(file, "")
    return struct(
        path = file.dirname,
        short_path = paths.dirname(file.short_path),
    )
