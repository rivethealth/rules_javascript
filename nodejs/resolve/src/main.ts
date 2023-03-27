import {
  printStarlark,
  StarlarkDict,
  StarlarkEqualStatement,
  StarlarkFile,
  StarlarkString,
  StarlarkValue,
  StarlarkVariable,
} from "@better-rules-javascript/util-starlark";
import { ArgumentParser } from "argparse";
import fetch from "node-fetch";
import { Version } from "./version";

const PLATFORMS: { [key: string]: string } = {
  "darwin-arm64.tar.gz": "darwin_arm64",
  "darwin-x64.tar.gz": "darwin_x86_64",
  "linux-arm64.tar.xz": "linux_arm64",
  "linux-x64.tar.xz": "linux_x86_64",
  "win-x64.zip": "windows_x86_64",
};

async function getNodeJsVersions(): Promise<Version[]> {
  const response = await fetch("https://nodejs.org/dist/index.json");
  const json = await response.json();

  return json
    .map(({ version }: any) => Version.parse(version.slice(1)))
    .sort(Version.compare);
}

interface NodeJsArtifact {
  filename: string;
  sha: string;
  type: string;
}

async function resolveNodeJs(version: Version): Promise<NodeJsArtifact[]> {
  const response = await fetch(
    `https://nodejs.org/dist/v${Version.serialize(version)}/SHASUMS256.txt`,
  );
  const text = await response.text();

  const artifacts: NodeJsArtifact[] = [];
  for (const line of text.trimEnd().split("\n")) {
    const [sha, filename] = line.split(/\s+/);
    const type = PLATFORMS[filename.replace(/^node-v[\d.]+-/, "")];
    if (type) {
      artifacts.push({ filename, sha, type });
    }
  }
  return artifacts;
}

function starlarkFile(
  versions: { artifacts: NodeJsArtifact[]; version: Version }[],
): StarlarkFile {
  const repositoryItems: [StarlarkValue, StarlarkValue][] = versions.map(
    ({ version, artifacts }) => [
      new StarlarkString(Version.serialize(version)),
      new StarlarkDict(
        artifacts.map((info) => [
          new StarlarkString(info.type),
          new StarlarkDict([
            [new StarlarkString("sha256"), new StarlarkString(info.sha)],
            [
              new StarlarkString("prefix"),
              new StarlarkString(info.filename.replace(/(\.tar)?\.[^.]+$/, "")),
            ],
            [
              new StarlarkString("url"),
              new StarlarkString(
                `v${Version.serialize(version)}/${info.filename}`,
              ),
            ],
          ]),
        ]),
      ),
    ],
  );
  const repositories = new StarlarkDict(repositoryItems);
  const statement = new StarlarkEqualStatement(
    new StarlarkVariable("NODEJS_REPOSITORIES"),
    repositories,
  );
  return new StarlarkFile([statement]);
}

async function main() {
  const parser = new ArgumentParser();
  parser.add_argument("--command");
  parser.add_argument("--min-version", { dest: "minVersion", required: true });
  const args = parser.parse_args();

  const minVersion = Version.parse(args.minVersion);

  const versions = await getNodeJsVersions();
  const resolved = await Promise.all(
    versions
      .filter((version) => Version.compare(minVersion, version) <= 0)
      .map(async (version) => ({
        artifacts: await resolveNodeJs(version),
        version,
      })),
  );
  console.log('"""');
  console.log("Generated. Do not edit.");
  if (args.command) {
    console.log(args.command);
  }
  console.log('"""');
  console.log();
  const file = starlarkFile(resolved);
  process.stdout.write(printStarlark(file));
}

main().catch((error) => {
  console.error(error.stack);
  process.exit(1);
});
