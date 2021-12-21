const { default: HasteMap } = require("jest-haste-map");

// https://github.com/facebook/jest/issues/11781
class CustomHasteMap extends HasteMap {
  _ignore(filePath) {
    const ignorePattern = this._options.ignorePattern;
    const ignoreMatched =
      ignorePattern instanceof RegExp
        ? ignorePattern.test(filePath)
        : ignorePattern && ignorePattern(filePath);
    return ignoreMatched;
  }
}

module.exports = CustomHasteMap;
