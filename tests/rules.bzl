load("@better_rules_javascript//rules/protobuf/bzl:aspects.bzl", "js_proto_aspect")
load("@better_rules_javascript//rules/protobuf/bzl:rules.bzl", "js_proto_library_rule")

js_proto = js_proto_aspect("@better_rules_javascript_test//:js_protoc")

js_proto_library = js_proto_library_rule(js_proto)
