# Until 3.8.0 adds json
def _encode(value):
    if type(value) == "struct":
        return value.to_json()
    json = struct(a = value).to_json()
    return json[len("{\"a\":"):-len("}")]

json = struct(
    encode = _encode,
)
