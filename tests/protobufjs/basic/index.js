const proto = require("./pb");

const person = proto.example.proto.Person.create({ name: "First Middle Last" });
const serialized = proto.example.proto.Person.encode(person).finish();
const deserialized = proto.example.proto.Person.decode(serialized);

console.log(deserialized.name);
