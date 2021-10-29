# see http://wiki.commonjs.org/wiki/Packages/1.0
CjsInfo = provider(
    doc = "CommonJS-style package",
    fields = {
        "descriptor": "Descriptor file",
        "prefix": "Default prexfix for entries",
        "id": "ID",
        "root": "Root struct",
    },
)

def create_entry_set(entries = [], entry_sets = []):
    return struct(
        transitive_files = depset(
            [entry.file for entry in entries],
            transitive = [entry_set.transitive_files for entry_set in entry_sets],
        ),
        transitive_entries = depset(
            entries,
            transitive = [entry_set.transitive_entries for entry_set in entry_sets],
        ),
    )

def create_root(id, name, descriptor, links):
    """
    :param str id: ID
    :param str name: Name
    :param File descriptor: package.json descriptor
    :param list links: List of dependency structs
    """
    return struct(id = id, name = name, descriptor = descriptor, links = links)

def create_entry(root, name, file, label):
    """
    Create entry for CommonJS package

    :param str root: Root ID
    :param str name: Name
    :param File file: File
    """
    return struct(file = file, name = name, root = root, label = label)

def create_link(dep, name, label):
    """
    Create link for CommonJs package

    :param str dep: Dependency ID
    :param str name: Name
    :param Label label: Source label
    """
    return struct(dep = dep, name = name, label = label)

def create_extra_link(root, dep, label):
    """
    Create extra dep for CommonJs package
    """
    return struct(root = root, dep = dep, label = label)

def entry_json(entry):
    return struct(
        file = entry.file.path,
        name = entry.name,
        root = entry.root,
    )

def entry_runfile_json(entry):
    return struct(
        file = entry.file.short_path,
        name = entry.name,
        root = entry.root,
    )

def extra_link_json(extra_link):
    return struct(
        dep = extra_link.dep,
        label = str(extra_link.label),
        root = extra_link.root,
    )

def root_json(root):
    return struct(
        links = [link_json(link) for link in root.links],
        descriptor = str(root.descriptor.path),
        id = root.id,
        name = root.name,
        path = cjs_path(root.id),
    )

def root_runfile_json(root):
    return struct(
        links = [link_json(link) for link in root.links],
        descriptor = str(root.descriptor.short_path),
        id = root.id,
        name = root.name,
        path = cjs_path(root.id),
    )

def link_json(link):
    return struct(
        dep = link.dep,
        name = link.name,
        label = str(link.label),
    )

def cjs_path(id):
    return "".join([c if c.isalnum() else "_" for c in id.elems()])
