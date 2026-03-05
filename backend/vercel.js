const serverless = require("serverless-http");
const app = require("./src/app");
const connect_db = require("./src/config/db");

connect_db();
module.exports = serverless(app);