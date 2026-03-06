const mongoose = require("mongoose");
const Task = require("../models/task");

const isValidId = (id) => mongoose.Types.ObjectId.isValid(id);


exports.get_tasks = async (req, res) => {
  try {
    const tasks = await Task.find({ userId: req.userId }).sort({
      completed: 1,
      dueDate: 1,
      createdAt: -1
    });

    res.json(tasks);

  } catch (error) {
    res.status(500).json({ message: "Server error while fetching tasks" });
  }
};


exports.create_task = async (req, res) => {
  try {
    const { title, description, dueDate, priority } = req.body;

    if (!title || typeof title !== "string" || !title.trim()) {
      return res.status(400).json({ message: "Title is required" });
    }

    const allowedPriorities = ["LOW", "MEDIUM", "HIGH"];
    if (priority && !allowedPriorities.includes(priority)) {
      return res.status(400).json({ message: "Priority must be LOW, MEDIUM, or HIGH" });
    }

    let parsedDueDate = null;
    if (dueDate) {
      parsedDueDate = new Date(dueDate);
      if (isNaN(parsedDueDate.getTime())) {
        return res.status(400).json({ message: "Invalid dueDate format" });
      }
    }

    const task = await Task.create({
      userId: req.userId,
      title: title.trim(),
      description: description ? description.trim() : "",
      dueDate: parsedDueDate,
      priority: priority || "MEDIUM"
    });

    res.status(201).json(task);

  } catch (error) {
    res.status(500).json({ message: "Server error while creating task" });
  }
};


exports.update_task = async (req, res) => {
  try {
    const { id } = req.params;

    if (!isValidId(id)) {
      return res.status(400).json({ message: "Invalid task ID" });
    }

    const { userId, _id, __v, createdAt, updatedAt, ...safeUpdate } = req.body;

    const allowedPriorities = ["LOW", "MEDIUM", "HIGH"];
    if (safeUpdate.priority && !allowedPriorities.includes(safeUpdate.priority)) {
      return res.status(400).json({ message: "Priority must be LOW, MEDIUM, or HIGH" });
    }

    if (safeUpdate.dueDate !== undefined && safeUpdate.dueDate !== null) {
      const d = new Date(safeUpdate.dueDate);
      if (isNaN(d.getTime())) {
        return res.status(400).json({ message: "Invalid dueDate format" });
      }
      safeUpdate.dueDate = d;
    }

    const task = await Task.findOneAndUpdate(
      { _id: id, userId: req.userId },
      safeUpdate,
      { new: true, runValidators: true }
    );

    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    res.json(task);

  } catch (error) {
    res.status(500).json({ message: "Server error while updating task" });
  }
};


exports.delete_task = async (req, res) => {
  try {
    const { id } = req.params;

    if (!isValidId(id)) {
      return res.status(400).json({ message: "Invalid task ID" });
    }

    const task = await Task.findOneAndDelete({ _id: id, userId: req.userId });

    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    res.json({ message: "Task deleted" });

  } catch (error) {
    res.status(500).json({ message: "Server error while deleting task" });
  }
};


exports.toggle_complete = async (req, res) => {
  try {
    const { id } = req.params;

    if (!isValidId(id)) {
      return res.status(400).json({ message: "Invalid task ID" });
    }

    const task = await Task.findOne({ _id: id, userId: req.userId });

    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    task.completed = !task.completed;
    await task.save();

    res.json(task);

  } catch (error) {
    res.status(500).json({ message: "Server error while toggling task" });
  }
};