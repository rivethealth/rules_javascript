const parse = require("module-details-from-path");

const details = parse(__filename);

console.log(details.name);
console.log(details.path);
