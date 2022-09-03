module.exports = {
  transformIgnorePatterns: [],
  transform: {
    "\\.m?js$": ["babel-jest", { configFile: "./babel.config.js" }],
  },
};
