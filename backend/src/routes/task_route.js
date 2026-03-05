const express = require("express");
const router = express.Router();

const auth_middleware = require("../middleware/auth");

const {
  get_tasks,
  create_task,
  update_task,
  delete_task,
  toggle_complete
} = require("../controllers/task_controller");


router.get("/", auth_middleware, get_tasks);

router.post("/", auth_middleware, create_task);

router.put("/:id", auth_middleware, update_task);

router.delete("/:id", auth_middleware, delete_task);

router.patch("/:id/complete", auth_middleware, toggle_complete);


module.exports = router;