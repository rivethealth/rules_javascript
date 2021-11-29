load(":aspects.bzl", "ts_proto")
load("@better_rules_typescript//protobuf:rules.bzl", "ts_proto_libraries_rule")

ts_proto_libraries = ts_proto_libraries_rule(ts_proto)
