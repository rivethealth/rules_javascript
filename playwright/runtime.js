const { Dirent } = require("node:fs");

Dirent.prototype.isFile = function () {
  return !this.isDirectory();
};
