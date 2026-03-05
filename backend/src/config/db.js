const mongoose = require("mongoose");

const connect_db = async () => {
  if (mongoose.connection.readyState >= 1) {
    return;
  }

  await mongoose.connect(process.env.MONGO_URI);

  console.log("MongoDB connected");
};

module.exports = connect_db;