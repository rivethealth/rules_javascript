JsInfo = provider(
    doc = "JavaScript",
    fields = {
        "transitive_files": "Depset of files (descriptors, JavaScript, data files)",
    },
)

def create_js_info(cjs_root, files = [], deps = []):
    return JsInfo(
        transitive_files = depset(files, transitive = [js_info.transitive_files for js_info in ([cjs_root] if cjs_root and files else []) + deps]),
    )

def js_npm_label(repo):
    return "@%s//:lib" % repo

def js_npm_inner_label(repo):
    return "@%s//:lib.inner" % repo
