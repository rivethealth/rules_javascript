import { Reader } from "protobufjs/minimal";
import { Person } from "./example/proto/person";

const person: Person = { name: "First Middle Last", place: undefined };
const serialized = Person.encode(person).finish();
const deserialized = Person.decode(Reader.create(serialized));

console.log(deserialized.name);
