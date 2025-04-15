load("@bazel_skylib//lib:shell.bzl", "shell")
load("@rules_pkg//pkg:providers.bzl", "PackageFilegroupInfo")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("//util:path.bzl", "runfile_path")

def _pkg_install_impl(ctx):
    actions = ctx.actions
    install = ctx.executable._install
    install_default = ctx.attr._install[DefaultInfo]
    install_manifest_gen = ctx.executable._install_manifest_gen
    install_manifest_gen_default = ctx.attr._install_manifest_gen[DefaultInfo]
    name = ctx.attr.name
    path = ctx.attr.path
    pkg_filegroup = ctx.attr.pkg[PackageFilegroupInfo]
    runner = ctx.file._runner
    workspace_name = ctx.workspace_name

    merge_args = actions.args()
    manifests = []
    srcs = []

    manifest = actions.declare_file("%s.dir-manifest.json" % name)
    args = actions.args()
    args.add("--origin")
    for (dirs, origin) in pkg_filegroup.pkg_dirs:
        for dest in dirs.dirs:
            args.add("--dir")
            args.add(dest)
            args.add(origin)
    args.add(manifest)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)
    actions.run(
        arguments = [args],
        executable = install_manifest_gen,
        execution_requirements = {
            "requires-worker-protocol": "json",
            "supports-workers": "1",
        },
        outputs = [manifest],
        progress_message = "Generating manifest for %{label} directories",
    )
    manifests.append(manifest)
    merge_args.add("--manifest", manifest)

    manifest = actions.declare_file("%s.symlink-manifest.json" % name)
    args = actions.args()
    args.add("--origin")
    for (symlink, origin) in pkg_filegroup.pkg_symlinks:
        args.add("--symlink")
        args.add("_%s" % symlink.destination)
        args.add(symlink.target)
        args.add(origin)
    args.add(manifest)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)
    actions.run(
        arguments = [args],
        executable = install_manifest_gen,
        execution_requirements = {
            "requires-worker-protocol": "json",
            "supports-workers": "1",
        },
        outputs = [manifest],
        progress_message = "Generating manifest for %{label} symlinks",
    )
    manifests.append(manifest)
    merge_args.add("--manifest", manifest)

    for (files, origin) in pkg_filegroup.pkg_files:
        executable = files.attributes["mode"].startswith("7") if files.attributes else False
        for dest, src in files.dest_src_map.items():
            manifest = actions.declare_file("%s.pkg/%s.manifest.json" % (name, dest))
            args = actions.args()
            args.add("--origin")
            args.add("--file")
            args.add(dest)
            args.add(src.path)
            args.add(runfile_path(workspace_name, src))
            args.add(json.encode(executable))
            args.add(origin)
            args.add(manifest)
            args.set_param_file_format("multiline")
            args.use_param_file("@%s", use_always = True)
            actions.run(
                arguments = [args],
                executable = install_manifest_gen,
                execution_requirements = {
                    "requires-worker-protocol": "json",
                    "supports-workers": "1",
                },
                inputs = [src],
                outputs = [manifest],
                progress_message = "Generating manifest for %s" % dest,
            )
            manifests.append(manifest)
            srcs.append(src)
            merge_args.add("--manifest", manifest)

    manifest = actions.declare_file("%s.manifest.json" % name)
    merge_args.add(manifest)
    merge_args.set_param_file_format("multiline")
    merge_args.use_param_file("@%s", use_always = True)
    actions.run(
        arguments = [merge_args],
        executable = install_manifest_gen,
        execution_requirements = {
            "requires-worker-protocol": "json",
            "supports-workers": "1",
        },
        inputs = manifests,
        outputs = [manifest],
        progress_message = "Merging manifests for %{label}",
    )

    executable = actions.declare_file(name)
    actions.expand_template(
        template = runner,
        output = executable,
        substitutions = {
            "%{install}": shell.quote(runfile_path(workspace_name, install)),
            "%{manifest}": shell.quote(runfile_path(workspace_name, manifest)),
            "%{path}": shell.quote(path),
        },
        is_executable = True,
    )

    runfiles = ctx.runfiles(files = [manifest] + srcs)
    runfiles = runfiles.merge(install_default.default_runfiles)
    default_info = DefaultInfo(
        executable = executable,
        runfiles = runfiles,
    )

    return [default_info]

pkg_install = rule(
    attrs = {
        "path": attr.string(mandatory = True),
        "pkg": attr.label(
            mandatory = True,
            providers = [PackageFilegroupInfo],
        ),
        "_install": attr.label(
            cfg = "target",
            default = "//pkg/install:bin",
            executable = True,
        ),
        "_install_manifest_gen": attr.label(
            cfg = "exec",
            default = "//pkg/install-manifest-gen:bin",
            executable = True,
        ),
        "_runner": attr.label(
            default = ":install-runner.sh.tpl",
            allow_single_file = True,
        ),
    },
    executable = True,
    implementation = _pkg_install_impl,
)
