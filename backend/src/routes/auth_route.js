const express = require("express");
const router = express.Router();

const {
  register,
  login,
  forgotPassword,
  changePassword,
  deleteAccount
} = require("../controllers/auth_controller");

const authMiddleware = require("../middleware/auth_middleware");

router.post("/register", register);
router.post("/login", login);
router.post("/forgot-password", forgotPassword);
router.put("/change-password", authMiddleware, changePassword);
router.delete("/delete-account", authMiddleware, deleteAccount);

module.exports = router;