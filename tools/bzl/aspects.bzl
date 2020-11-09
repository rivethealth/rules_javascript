load("//rules/prettier/bzl:aspects.bzl", "format_aspect")

format = format_aspect(
    "@better_rules_javascript//tools:prettier",
)
