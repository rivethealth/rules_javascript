def runfile_path(ctx, file):
    path = file.short_path
    if path.startswith("../"):
        path = path[len("../"):]
    else:
        path = "%s/%s" % (ctx.workspace_name, path)
    return path
