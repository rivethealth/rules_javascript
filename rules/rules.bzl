load("//nodejs:providers.bzl", "nodejs_runtime_rule")
load("//ts-proto:rules.bzl", "ts_proto_libraries_rule")
load(":aspects.bzl", "ts_proto")

ts_proto_libraries = ts_proto_libraries_rule(ts_proto, "@better_rules_javascript//rules:ts_protoc")

nodejs_runtime = nodejs_runtime_rule("@better_rules_javascript//rules:nodejs_runtime")
