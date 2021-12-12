const path = require("path");

module.exports = {
  entry: path.resolve(`${process.env.WEBPACK_INPUT_ROOT}/main.js`),
  mode: 'production',
  output: {
    filename: path.basename(process.env.WEBPACK_OUTPUT),
    path: path.resolve(path.dirname(process.env.WEBPACK_OUTPUT)),
  },
};
