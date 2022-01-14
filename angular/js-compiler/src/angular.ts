/**
 * @see https://github.com/angular/angular/blob/master/packages/compiler-cli/src/ngtsc/resource/src/loader.ts
 */
export function stylePath(path: string) {
  return path.replace(/(\.scss|\.sass|\.less|\.styl)$/, ".css");
}
