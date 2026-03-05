const app = require("../src/app");
const connectDB = require("../src/config/db");
const { connectRedis } = require("../src/config/redis");

let isConnected = false;

module.exports = async (req, res) => {
  if (!isConnected) {
    await connectDB();
    await connectRedis();
    isConnected = true;
    console.log("DB + Redis connected 🚀");
  }

  return app(req, res);
};

module.exports.config = {
  runtime: "nodejs"
};