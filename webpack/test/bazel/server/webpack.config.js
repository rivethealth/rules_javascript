const HtmlWebpackPlugin = require("html-webpack-plugin");

module.exports = {
  entry: "./main.js",
  plugins: [new HtmlWebpackPlugin()],
};
