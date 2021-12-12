JsFile = provider(
    doc = "JavaScript file",
    fields = {
        "path": "Path",
    },
)

JsInfo = provider(
    doc = "JavaScript",
    fields = {
        "name": "CommonJS name",
        "package": "CommonJS package struct",
        "transitive_deps": "Depset of dependency structs",
        "transitive_descriptors": "Depset of package descriptor files",
        "transitive_js": "Depset of JavaScript files",
        "transitive_packages": "Depset of packages",
        "transitive_srcs": "Depset of sources",
    },
)
