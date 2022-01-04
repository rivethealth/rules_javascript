const webpack = require("/home/paul/dev/rivethealth/watchpack-test/node_modules/webpack/lib/index.js");
const config = require("./server/webpack.config");
const webpackDevServer = require("/home/paul/dev/rivethealth/watchpack-test/node_modules/webpack-dev-server/lib/Server.js");

const compiler = webpack(config);
const server = new webpackDevServer({}, compiler);

server.start().then(() => {
  console.error("LISTENING");
});
