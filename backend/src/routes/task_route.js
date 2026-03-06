const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/auth");

const {
  get_tasks,
  create_task,
  update_task,
  delete_task,
  toggle_complete
} = require("../controllers/task_controller");

router.get("/", authMiddleware, get_tasks);
router.post("/", authMiddleware, create_task);
router.put("/:id", authMiddleware, update_task);
router.delete("/:id", authMiddleware, delete_task);
router.patch("/:id/complete", authMiddleware, toggle_complete);

module.exports = router;