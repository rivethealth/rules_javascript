load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def test_repositories0():
    # Skylib

    SKYLIB_VERSION = "16de038c484145363340eeaf0e97a0c9889a931b"

    http_archive(
        name = "bazel_skylib",
        sha256 = "96e0cd3f731f0caef9e9919aa119ecc6dace36b149c2f47e40aa50587790402b",
        strip_prefix = "bazel-skylib-%s" % SKYLIB_VERSION,
        urls = ["https://github.com/bazelbuild/bazel-skylib/archive/%s.tar.gz" % SKYLIB_VERSION],
    )

    # File

    FILE_VERSION = "d97911bed8e3b90499c5daec7e5485f50c008322"

    http_archive(
        name = "rules_file",
        sha256 = "d22158e37b0ace1d7ad6623be6b5aa31232499174a21ee1776f3a39e7e252b4c",
        strip_prefix = "rules_file-%s" % FILE_VERSION,
        url = "https://github.com/rivethealth/rules_file/archive/%s.tar.gz" % FILE_VERSION,
    )

    # Protobuf

    PROTO_VERSION = "7e4afce6fe62dbff0a4a03450143146f9f2d7488"

    http_archive(
        name = "rules_proto",
        sha256 = "8e7d59a5b12b233be5652e3d29f42fba01c7cbab09f6b3a8d0a57ed6d1e9a0da",
        strip_prefix = "rules_proto-%s" % PROTO_VERSION,
        urls = ["https://github.com/bazelbuild/rules_proto/archive/%s.tar.gz" % PROTO_VERSION],
    )

    # Protobuf

    PROTO_GRPC_VERSION = "2.0.0"

    http_archive(
        name = "rules_proto_grpc",
        sha256 = "d771584bbff98698e7cb3cb31c132ee206a972569f4dc8b65acbdd934d156b33",
        strip_prefix = "rules_proto_grpc-%s" % PROTO_GRPC_VERSION,
        urls = ["https://github.com/rules-proto-grpc/rules_proto_grpc/archive/%s.tar.gz" % PROTO_GRPC_VERSION],
    )

    # Python

    PYTHON_VERSION = "0.6.0"

    http_archive(
        name = "rules_python",
        sha256 = "a30abdfc7126d497a7698c29c46ea9901c6392d6ed315171a6df5ce433aa4502",
        strip_prefix = "rules_python-%s" % PYTHON_VERSION,
        url = "https://github.com/bazelbuild/rules_python/archive/%s.tar.gz" % PYTHON_VERSION,
    )

    # Rivet Bazel Util

    RIVET_BAZEL_UTIL_VERSION = "d388fb2a617986557c25972ef5b2eb64c259c787"

    http_archive(
        name = "rivet_bazel_util",
        sha256 = "06d0b91104f1f41b3ffce7bb8082220ab5427cf2392ccd33216e4fe371d3dae3",
        strip_prefix = "rivet-bazel-util-%s" % RIVET_BAZEL_UTIL_VERSION,
        url = "https://github.com/rivethealth/rivet-bazel-util/archive/%s.tar.gz" % RIVET_BAZEL_UTIL_VERSION,
    )
