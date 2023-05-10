const express = require("express");
const app = express();
require("dotenv").config();
app.get("/", function (req, res) {
  res.json("Server responded!");
});
app.listen(process.env.PORT, function () {
  console.log(`App listening on port ${process.env.PORT}!`);
});
