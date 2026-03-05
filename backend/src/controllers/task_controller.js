const Task = require("../models/task");


exports.get_tasks = async (req, res) => {
  try {

    const tasks = await Task.find({ userId: req.userId });

    res.json(tasks);

  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};


exports.create_task = async (req, res) => {
  try {

    const { title, description } = req.body;

    const task = await Task.create({
      userId: req.userId,
      title,
      description
    });

    res.status(201).json(task);

  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};


exports.update_task = async (req, res) => {
  try {

    const task = await Task.findOneAndUpdate(
      { _id: req.params.id, userId: req.userId },
      req.body,
      { new: true }
    );

    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    res.json(task);

  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};


exports.delete_task = async (req, res) => {
  try {

    const task = await Task.findOneAndDelete({
      _id: req.params.id,
      userId: req.userId
    });

    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    res.json({ message: "Task deleted" });

  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};


exports.toggle_complete = async (req, res) => {
  try {

    const task = await Task.findOne({
      _id: req.params.id,
      userId: req.userId
    });

    if (!task) {
      return res.status(404).json({ message: "Task not found" });
    }

    task.completed = !task.completed;

    await task.save();

    res.json(task);

  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};