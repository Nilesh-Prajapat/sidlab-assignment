const mongoose = require("mongoose");
const config = require("./config");

const connect_db = async () => {
  if (mongoose.connection.readyState >= 1) {
    return;
  }

  await mongoose.connect(config.mongoURI);

  console.log("MongoDB connected");
};

module.exports = connect_db;