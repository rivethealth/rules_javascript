load("@better_rules_javascript//rules/protobuf:aspects.bzl", "js_proto_aspect")
load("//rules/prettier:aspects.bzl", "format_aspect")

format = format_aspect(
    "@better_rules_javascript//tools:prettier",
)

js_proto = js_proto_aspect("@better_rules_javascript//rules:js_protoc", "better_rules_javascript_proto")
