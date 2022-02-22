import HasteMap from "jest-haste-map";

// https://github.com/facebook/jest/issues/2145
class CustomHasteMap extends (<any>HasteMap) {
  _ignore(filePath: string) {
    const ignorePattern = this._options.ignorePattern;
    const ignoreMatched =
      ignorePattern instanceof RegExp
        ? ignorePattern.test(filePath)
        : ignorePattern && ignorePattern(filePath);
    return ignoreMatched;
  }
}

export = CustomHasteMap;
