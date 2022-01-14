AngularCompilerInfo = provider(
    doc = "TypeScript compiler",
    fields = {
        "bin": "Executable",
        "js_deps": "JS deps",
        "ts_deps": "TS deps",
        "js_compiler": "Executable",
        "resource_compiler": "Resource compiler",
        "tsc_bin": "TypeScript compiler",
    },
)

# See https://github.com/angular/angular/blob/master/packages/compiler-cli/src/ngtsc/resource/src/loader.ts
def resource_path(path):
    if path.endswith(".scss"):
        path = path[:-len(".scss")] + ".css"
    if path.endswith(".sass"):
        path = path[:-len(".sass")] + ".css"
    if path.endswith(".less"):
        path = path[:-len(".less")] + ".css"
    if path.endswith(".styl"):
        path = path[:-len(".styl")] + ".styl"
    return path + ".cjs"
