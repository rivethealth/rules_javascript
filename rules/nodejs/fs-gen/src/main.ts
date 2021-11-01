import { ArgumentParser } from "argparse";
import { Entry, ExtraLink, gen, Root } from "./gen";

function rootArg(value: string) {
  return Root.json().fromJson(JSON.parse(value));
}

function extraDepArg(value: string) {
  return ExtraLink.json().fromJson(JSON.parse(value));
}

function entrysArg(value: string) {
  return Entry.json().fromJson(JSON.parse(value));
}

const parser = new ArgumentParser({
  description: "Resolve dependency information into LinkFs",
});
const subparsers = parser.add_subparsers({ dest: "command" });

const genParser = subparsers.add_parser("gen");
genParser.add_argument("--global", {
  action: "append",
  default: [],
  dest: "globals",
});
genParser.add_argument("--extra-link", {
  action: "append",
  default: [],
  dest: "extraLinks",
  type: extraDepArg,
});
genParser.add_argument("--entry", {
  action: "append",
  default: [],
  dest: "entries",
  type: entrysArg,
});
genParser.add_argument("--runfiles", { default: false, type: Boolean });
genParser.add_argument("--root", {
  action: "append",
  default: [],
  dest: "roots",
  type: rootArg,
});
genParser.add_argument("mount", { help: "Path to mount" });
genParser.add_argument("outputPath", { metavar: "output" });

const args = parser.parse_args();

switch (args.command) {
  case "gen":
    gen(args);
    break;
}
