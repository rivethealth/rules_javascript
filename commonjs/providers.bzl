CjsDescriptorInfo = provider(
    fields = {
        "descriptors": "List of files",
        "path": "Root path",
    },
)

# see http://wiki.commonjs.org/wiki/Packages/1.0
CjsInfo = provider(
    doc = "CommonJS-style package",
    fields = {
        "descriptors": "Descriptor files",
        "package": "Package struct",
        "name": "Name",
    },
)

def create_package(id, path, short_path, label):
    """Create package struct.

    Args:
        id: ID
        path: Part to directory
        short_path: Short path to directory
        descriptors: List of package descriptors
        label: Source label
    """
    return struct(
        id = id,
        label = label,
        path = path,
        short_path = short_path,
    )

def create_dep(id, name, dep, label):
    """Create link for CommonJs package.

    Args:
        id: Package ID
        name: Name
        dep: Dependency package ID
        label: Source label
    """
    return struct(
        dep = dep,
        id = id,
        label = label,
        name = name,
    )

def create_global(id, name):
    return struct(
        id = id,
        name = name,
    )

def cjs_path(id):
    return "".join([c if c.isalnum() else "_" for c in id.elems()])
