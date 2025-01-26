import { getPluginConfiguration } from "@yarnpkg/cli";
import { Configuration, Locator, Project, structUtils } from "@yarnpkg/core";
import { npath } from "@yarnpkg/fslib";

export async function yarnProject(dir: string) {
  const yarnPath = npath.toPortablePath(dir.replace(/\/$/g, ""));
  const configuration = await Configuration.find(
    yarnPath,
    getPluginConfiguration(),
  );
  const { project } = await Project.find(configuration, yarnPath);
  return { configuration, project };
}

function conditionsParse(conditions: string): Map<string, string[]> {
  const result = new Map<string, string[]>();
  for (const part of conditions.split(/[ ()]/)) {
    const [first, second] = part.split("=");
    if (!second) {
      continue;
    }
    let array = result.get(first);
    if (!array) {
      array = [];
      result.set(first, array);
    }
    array.push(second);
  }
  return result;
}

export async function getPackageInfos(
  project: Project,
): Promise<YarnPackageInfos> {
  await project.restoreInstallState();

  const packages: YarnPackageInfos = new Map();

  for (const pkg of project.storedPackages.values()) {
    const conditions = pkg.conditions
      ? conditionsParse(pkg.conditions)
      : new Map();
    const package_: YarnPackageInfo = {
      constraints: {
        cpu: conditions.get("cpu"),
        libc: conditions.get("libc"),
        os: conditions.get("os"),
      },
      locator: pkg,
      dependencies: new Map(
        [...pkg.dependencies.values()].map((dependency) => {
          const resolutionHash = project.storedResolutions.get(
            dependency.descriptorHash,
          )!;
          const resolution = project.storedPackages.get(resolutionHash)!;
          return [
            structUtils.stringifyIdent(dependency),
            structUtils.stringifyLocator(resolution),
          ];
        }),
      ),
    };

    packages.set(structUtils.stringifyLocator(pkg), package_);
  }

  return packages;
}

export type YarnPackageInfos = Map<string, YarnPackageInfo>;

export type YarnDependencies = Map<string, string>;

export interface YarnPackageInfo {
  constraints: YarnConstraints;
  dependencies: YarnDependencies;
  locator: Locator;
}

export interface YarnConstraints {
  cpu: Constraint<Cpu>;
  libc: Constraint<Libc>;
  os: Constraint<Os>;
}

/**
 * Note: Supports inclusions but not exclusions
 */
export type Constraint<T> = T[] | undefined;

export type Cpu = string;

export type Libc = string;

export type Os = string;
