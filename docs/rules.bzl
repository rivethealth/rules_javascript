load("@bazel_skylib//lib:paths.bzl", "paths")
load("@io_bazel_stardoc//stardoc:stardoc.bzl", _stardoc = "stardoc")

def stardoc(name, lib, files, visibility = None):
    stardocs = []
    for file in files:
        file_name = file.replace("//", "").replace("/", "_").replace(":", "_")
        rule_name = file_name.replace(".bzl", "_doc")
        stardoc_rule_name = file_name.replace(".bzl", "_stardoc")
        stardocs.append(rule_name)
        _stardoc(
            name = stardoc_rule_name,
            out = paths.replace_extension(file_name, ".stardoc.md"),
            input = file,
            deps = [lib],
            visibility = ["//visibility:private"],
        )

        native.genrule(
            name = rule_name,
            cmd = """
                (echo '# %s' && echo && cat $(location %s)) > $@
            """ % (file, paths.replace_extension(file_name, ".stardoc.md")),
            srcs = [paths.replace_extension(file_name, ".stardoc.md")],
            outs = [paths.replace_extension(file_name, ".md")],
            visibility = ["//visibility:private"],
        )

    native.genrule(
        name = name,
        cmd = """
            (
                echo '# Contents'
                echo '<!-- START doctoc -->' &&
                echo '<!-- END doctoc -->' &&
                cat %s
            ) > $@
        """ % " ".join(["$(location %s)" % stardoc for stardoc in stardocs]),
        outs = ["%s.md" % native.package_name().replace("/doc", "")],
        srcs = [":%s" % stardoc for stardoc in stardocs],
        visibility = visibility,
    )
