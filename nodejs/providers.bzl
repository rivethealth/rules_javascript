load("//commonjs:providers.bzl", "entry_json", "entry_runfile_json", "extra_link_json", "root_json", "root_runfile_json")
load("//util:json.bzl", "json")

def gen_fs(actions, gen, file, mount, entries, extra_links, roots, globals, is_runfiles):
    args = actions.args()
    args.set_param_file_format("multiline")
    args.add("gen")
    args.add(mount)
    if is_runfiles:
        args.add("--runfiles")
        args.add("true")
        args.add_all(entries, before_each = "--entry", map_each = _entry_runfile_arg)
        args.add_all(roots, before_each = "--root", map_each = _root_runfile_arg)
    else:
        args.add_all(entries, before_each = "--entry", map_each = _entry_arg)
        args.add_all(roots, before_each = "--root", map_each = _root_arg)
    args.add_all(extra_links, before_each = "--extra-link", map_each = _extra_link_arg)
    args.add_all(globals, before_each = "--global")
    args.add(file)

    actions.run(
        executable = gen.files_to_run.executable,
        tools = [gen.files_to_run],
        arguments = [args],
        mnemonic = "GenFs",
        outputs = [file],
    )

def js_info_gen_fs(actions, gen, file, mount, js_info, include_sources, is_runfiles):
    entries = [js_info.js_entry_set.transitive_entries]
    if include_sources:
        entries.append(js_info.src_entry_set.transitive_entries)
    gen_fs(
        actions,
        gen,
        file,
        mount,
        depset([], transitive = entries),
        js_info.transitive_extra_links,
        js_info.transitive_roots,
        js_info.transitive_globals,
        is_runfiles,
    )

def _entry_arg(entry):
    return json.encode(entry_json(entry))

def _entry_runfile_arg(entry):
    return json.encode(entry_runfile_json(entry))

def _extra_link_arg(extra_link):
    return json.encode(extra_link_json(extra_link))

def _root_arg(root):
    return json.encode(root_json(root))

def _root_runfile_arg(root):
    return json.encode(root_runfile_json(root))
