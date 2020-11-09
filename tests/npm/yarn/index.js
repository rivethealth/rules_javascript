console.time("require");
const express = require("express");
const http = require("http");
console.timeEnd("require");

const app = express();

const request = () => {
  http
    .request("http://localhost:8856", (res) => {
      let response = "";
      res.on("data", (chunk) => {
        response += chunk;
      });
      res.on("end", () => {
        console.log(response);
        process.exit();
      });
    })
    .end();
};

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.listen(8856, () => request());
