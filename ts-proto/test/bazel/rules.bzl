load("@better_rules_javascript//ts-proto:rules.bzl", "ts_proto_libraries_rule")
load("//:aspects.bzl", "ts_proto")

ts_proto_libraries = ts_proto_libraries_rule(ts_proto, ":ts_protoc")
