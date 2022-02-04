load("@bazel_skylib//lib:paths.bzl", "paths")
load("@io_bazel_stardoc//stardoc:stardoc.bzl", _stardoc = "stardoc")

def stardoc(name, lib, files, visibility = None):
    stardocs = []
    for file in files:
        file_name = file.replace("//", "").replace("/", "_").replace(":", "_")
        rule_name = file_name.replace(".bzl", "_doc")
        stardocs.append(rule_name)
        _stardoc(
            name = rule_name,
            out = paths.replace_extension(file_name, ".md"),
            input = file,
            deps = [lib],
            visibility = ["//visibility:private"],
        )

    native.filegroup(
        name = name,
        srcs = [":%s" % stardoc for stardoc in stardocs],
        visibility = visibility,
    )
