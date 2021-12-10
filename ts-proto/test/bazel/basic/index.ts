import { Person } from "./example/proto/person";
import { Reader } from "protobufjs/minimal";

const person: Person = { name: "First Middle Last", place: undefined };
const serialized = Person.encode(person).finish();
const deserialized = Person.decode(Reader.create(serialized));

console.log(deserialized.name);
