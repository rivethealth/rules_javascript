load("@better_rules_javascript//rules/javascript/bzl:rules.bzl", "js_library")
load("@better_rules_javascript//rules/nodejs/bzl:rules.bzl", "nodejs_binary")

package(default_visibility = ["//visibility:public"])

js_library(
    main = %{main},
    name = "js",
    deps = %{deps},
    js_name = %{package_name},
    srcs = glob(%{include}, %{exclude}),
    strip_prefix = "%s/%s" % (repository_name()[1:], %{prefix}),
)

%{binaries}
