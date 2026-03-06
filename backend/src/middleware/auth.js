const jwt = require("jsonwebtoken");
const config = require("../config/config");

const auth_middleware = (req, res, next) => {
  try {

    const authHeader = req.headers.authorization;

    if (!authHeader) {
      return res.status(401).json({ message: "No token provided" });
    }

    const token = authHeader.split(" ")[1];

    const decoded = jwt.verify(token, config.jwtSecret);

    req.userId = decoded.userId;

    next();

  } catch (error) {

    return res.status(401).json({ message: "Invalid or expired token" });

  }
};

module.exports = auth_middleware;