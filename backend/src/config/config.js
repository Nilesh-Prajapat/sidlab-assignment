require('dotenv').config();

module.exports = {

    mongoURI: process.env.MONGO_URI,
    jwtSecret: process.env.JWT_SECRET,
    jwtTime: process.env.JWT_TIME,
};