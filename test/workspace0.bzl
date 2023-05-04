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

    # Rules Pkg

    PKG_VERSION = "0aa9277cc66fa26b519a1ad8abac0215fc987484"

    http_archive(
        name = "rules_pkg",
        sha256 = "d808248021ffc77c731ef516f0efa67085aa8521bd8ccf72421ecf9274ab50d5",
        strip_prefix = "rules_pkg-%s" % PKG_VERSION,
        url = "https://github.com/bazelbuild/rules_pkg/archive/%s.tar.gz" % PKG_VERSION,
    )

    # File

    FILE_VERSION = "fd7ad6a7e9f3438fddb41683f33b6b4d07d067fe"

    http_archive(
        name = "rules_file",
        sha256 = "9108bf11fe1063bb6268f15506ea35c1a29e03cae651032d1da3d0f33561c5fd",
        strip_prefix = "rules_file-%s" % FILE_VERSION,
        url = "https://github.com/hello-seer/rules_file/archive/%s.zip" % FILE_VERSION,
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

    RIVET_BAZEL_UTIL_VERSION = "48453fd1e220fd16ce229b3812d8b9bb861296ad"

    http_archive(
        name = "rivet_bazel_util",
        sha256 = "6d82bcbe35a8293550642352da9cb2e6b0138c293e1af0eb282b020e9e1a5209",
        strip_prefix = "rivet-bazel-util-%s" % RIVET_BAZEL_UTIL_VERSION,
        url = "https://github.com/rivethealth/rivet-bazel-util/archive/%s.tar.gz" % RIVET_BAZEL_UTIL_VERSION,
    )
