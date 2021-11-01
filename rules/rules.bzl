load(":aspects.bzl", "ts_proto")
load("@better_rules_typescript//rules/protobuf:rules.bzl", "ts_proto_library_rule")

ts_proto_library = ts_proto_library_rule(ts_proto)
