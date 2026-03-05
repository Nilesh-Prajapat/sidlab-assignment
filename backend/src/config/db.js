const mongoose = require('mongoose');

const connect_db = async () => {
    try {
        console.log("Mongo URI:", process.env.MONGO_URI);
        const conn = await mongoose.connect(process.env.MONGO_URI);
        console.log(`✅ MongoDB connected: ${conn.connection.host}`);
    } catch (err) {
        console.error(`❌ MongoDB connection error: ${err.message}`);
        process.exit(1);
    }
};

module.exports = connect_db;