module.exports = {
  transformIgnorePatterns: [],
  transform: {
    "^.+\\.js$": ["babel-jest", { configFile: "./babel.config.js" }],
  },
  roots: ["../"],
};
