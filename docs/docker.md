# Docker

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Example](#example)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Use `nodejs_binary_archive` to create a tar and add that to the docker image.

# Example

```bzl
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary_archive")
load("@io_bazel_rules_docker//container:container.bzl", "container_image")

container_image(
    name = "image",
    base = "@base//image",
    directory = "/opt/example",
    entrypoint = ["/usr/local/bin/example"],
    symlinks = {
        "/usr/local/bin/example": "/opt/example/bin",
    },
    tars = [":tar"],
)

nodejs_binary_archive(
    name = "tar",
    dep = ":lib",
    main = "src/main.js",
)
```
