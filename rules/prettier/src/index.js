const { ArgumentParser } = require("argparse");
const fs = require("fs");
const prettier = require("prettier");

const parser = new ArgumentParser();
parser.add_argument("--config");
parser.add_argument("input");
parser.add_argument("output");

const args = parser.parse_args();

const options =
  args.config &&
  prettier.resolveConfig.sync(args.config, { config: args.config });
options.filepath = args.input;

const input = fs.readFileSync(args.input, "utf8");
const output = prettier.format(input, options);
fs.writeFileSync(args.output, output, "utf8");
