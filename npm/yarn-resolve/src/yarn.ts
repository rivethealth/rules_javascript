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

export async function getPackageInfos(
  project: Project,
): Promise<YarnPackageInfos> {
  await project.restoreInstallState();

  const packages: YarnPackageInfos = new Map();

  for (const pkg of project.storedPackages.values()) {
    const package_: YarnPackageInfo = {
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
  locator: Locator;
  dependencies: YarnDependencies;
}
