# Docker

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Example](#example)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Use `nodejs_binary_package` to create a tar and add that to the docker image.

# Example

```bzl
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary_package")
load("@rules_oci//oci:defs.bzl", "oci_image")

oci_image(
    name = "image",
    base = "@base",
    entrypoint = ["/usr/local/bin/example"],
    tars = ["image_layer"],
)

pkg_tar(
    name = "image_layer",
    package_dir = "/opt/example",
    symlinks = {
        "/usr/local/bin/example": "/opt/example/bin",
    },
    # Merges these tars together into one layer
    deps = [":tar"],
)

nodejs_binary_package(
    name = "tar",
    dep = ":lib",
    main = "src/main.js",
)
```
