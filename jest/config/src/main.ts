import { ArgumentParser } from "argparse";

const parser = new ArgumentParser({ prog: "jest-config" });
parser.add_argument("--extends");
parser.add_argument("--source", { required: true });
parser.add_argument("--root-dirs", {
  action: "append",
  default: [],
  dest: "rootDirs",
});
parser.add_argument("--root-dir");
