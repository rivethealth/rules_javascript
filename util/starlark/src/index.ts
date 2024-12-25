export type StarlarkValue =
  | StarlarkArray
  | StarlarkDict
  | StarlarkNone
  | StarlarkString;

export class StarlarkArray {
  constructor(readonly elements: StarlarkValue[]) {}
}

export class StarlarkDict {
  constructor(readonly elements: [StarlarkValue, StarlarkValue][]) {}
}

export class StarlarkNone {}

export class StarlarkString {
  constructor(readonly value: string) {}
}

export type StarlarkExpression = StarlarkVariable;

export class StarlarkVariable {
  constructor(readonly value: string) {}
}

export class StarlarkEqualStatement {
  constructor(
    readonly left: StarlarkVariable,
    readonly right: StarlarkValue,
  ) {}
}

export type StarlarkStatement = StarlarkEqualStatement;

export class StarlarkFile {
  constructor(readonly statements: StarlarkStatement[]) {}
}

function printArray(value: StarlarkArray, indent?: string | undefined): string {
  let output = "";
  output += "[";
  output += indent === undefined ? " " : "\n";
  for (const v of value.elements) {
    if (indent !== undefined) {
      output += indent + "    ";
    }
    output += printValue(v, indent === undefined ? indent : indent + "    ");
    output += ",";
    output += indent === undefined ? " " : "\n";
  }
  if (indent !== undefined) {
    output += indent;
  }
  output += "]";
  return output;
}

function printDict(value: StarlarkDict, indent?: string | undefined): string {
  let output = "";
  output += "{";
  output += indent === undefined ? " " : "\n";
  for (const [k, v] of value.elements) {
    if (indent !== undefined) {
      output += indent + "    ";
    }
    output += printValue(k);
    output += ": ";
    output += printValue(v, indent === undefined ? indent : indent + "    ");
    output += ",";
    output += indent === undefined ? " " : "\n";
  }
  if (indent !== undefined) {
    output += indent;
  }
  output += "}";
  return output;
}

function printNone() {
  return "None";
}

function printString(value: StarlarkString): string {
  return JSON.stringify(value.value);
}

function printValue(value: StarlarkValue, indent?: string | undefined): string {
  if (value instanceof StarlarkArray) {
    return printArray(value, indent);
  }
  if (value instanceof StarlarkDict) {
    return printDict(value, indent);
  }
  if (value instanceof StarlarkNone) {
    return printNone();
  }
  if (value instanceof StarlarkString) {
    return printString(value);
  }
  throw new Error("Unreognized value");
}

function printVariable(value: StarlarkVariable): string {
  return value.value;
}

function printEqualStatement(value: StarlarkEqualStatement): string {
  let output = "";
  output += printVariable(value.left);
  output += " = ";
  output += printValue(value.right, "");
  output += "\n";
  return output;
}

function printStatement(value: StarlarkStatement): string {
  if (value instanceof StarlarkEqualStatement) {
    return printEqualStatement(value);
  }
  throw new Error("Unrecognized value");
}

export function printStarlark(file: StarlarkFile): string {
  return file.statements
    .map((statement) => printStatement(statement))
    .join("\n");
}
