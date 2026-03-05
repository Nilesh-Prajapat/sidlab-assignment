const app = require("./src/app");
const connectDB = require("./src/config/db");
require("dotenv").config();

let isConnected = false;

module.exports = async (req, res) => {
  if (!isConnected) {
    await connectDB();
    isConnected = true;
    console.log("DB connected 🚀");
  }

  return app(req, res);
};
