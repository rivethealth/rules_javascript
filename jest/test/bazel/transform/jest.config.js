module.exports = {
  transformIgnorePatterns: [],
  transform: {
    "\\.m?js$": [
      "babel-jest",
      { configFile: process.cwd() + "/babel.config.js" },
    ],
  },
};
