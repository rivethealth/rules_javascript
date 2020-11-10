load("@bazel_skylib//lib:paths.bzl", "paths")
load("@io_bazel_stardoc//stardoc:stardoc.bzl", "stardoc")

def stardocs(dep):
    stardocs = []
    for file in native.glob(["**/*.bzl"]):
        name = paths.replace_extension(file, "_doc").replace("/", "_")
        stardocs.append(name)
        stardoc(
            name = name,
            out = paths.replace_extension(file, ".md").replace("/", "_"),
            input = file,
            deps = [dep],
        )

    native.filegroup(
        name = "doc",
        srcs = stardocs,
    )
