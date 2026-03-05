const app = require("./src/app");
const connect_db = require("./src/config/db");
require("dotenv").config();

let isConnected = false;

module.exports = async (req, res) => {
  if (!isConnected) {
    await connect_db();
    isConnected = true;
    console.log("DB connected 🚀");
  }

  return app(req, res);
};
