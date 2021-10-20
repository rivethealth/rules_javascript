load("@bazel_skylib//lib:paths.bzl", "paths")
load("@io_bazel_stardoc//stardoc:stardoc.bzl", _stardoc = "stardoc")

def stardoc(lib, files):
    stardocs = []
    for file in files:
        name = file.replace("@", "").replace("//", "_").replace("/", "_").replace(":", "_")
        rule_name = paths.replace_extension(name, "_doc")
        stardocs.append(rule_name)
        _stardoc(
            name = rule_name,
            out = paths.replace_extension(name, ".md"),
            input = file,
            deps = [lib],
        )

    name = lib.replace("@", "").replace("//", "_").replace("/", "_").replace(":", "_")
    native.filegroup(
        name = name,
        srcs = [":%s" % stardoc for stardoc in stardocs],
    )
