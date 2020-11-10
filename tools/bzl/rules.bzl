load(":aspects.bzl", "js_proto")
load("@better_rules_javascript//rules/protobuf/bzl:rules.bzl", "js_proto_library_rule")

js_proto_library = js_proto_library_rule(js_proto)
