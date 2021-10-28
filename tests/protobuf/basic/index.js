const { Person } = require('@better_rules_javascript_test/proto/example/proto/person_pb')

const person = new Person();
person.setName('First Middle Last')
const serialized = person.serializeBinary();
const deserialized = Person.deserializeBinary(serialized);

console.log(deserialized.getName());
