AngularCompilerInfo = provider(
    doc = "TypeScript compiler",
    fields = {
        "bin": "Executable",
        "js_deps": "JS deps",
        "ts_deps": "TS deps",
        "js_compiler": "Executable",
        "resource_compiler": "Resource compiler",
    },
)

def resource_path(path):
    return path + ".cjs"
