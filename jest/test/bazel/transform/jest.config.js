const path = require("node:path");

module.exports = {
  transformIgnorePatterns: [],
  transform: {
    "\\.m?js$": [
      "babel-jest",
      { configFile: path.join(__dirname, "babel.config.js") },
    ],
  },
};
