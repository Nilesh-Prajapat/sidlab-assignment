const Task = require("../models/task");

const computeStatus = (task) => {
  if (task.completed) return "DONE";
  if (task.dueDate && new Date() > new Date(task.dueDate)) return "OVERDUE";
  return "ACTIVE";
};

exports.get_tasks = async (req, res) => {
  try {
    const tasks = await Task.find({ userId: req.userId }).sort({
      completed: 1,
      dueDate: 1,
      createdAt: -1
    });

    const result = tasks.map((task) => {
      const obj = task.toObject();
      obj.status = computeStatus(obj);
      return obj;
    });

    res.json(result);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};

exports.create_task = async (req, res) => {
  try {
    const { title, description, dueDate, priority } = req.body;

    const task = await Task.create({
      userId: req.userId,
      title,
      description: description || "",
      dueDate: dueDate || null,
      priority: priority || "MEDIUM"
    });

    const obj = task.toObject();
    obj.status = computeStatus(obj);

    res.status(201).json(obj);
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

    const obj = task.toObject();
    obj.status = computeStatus(obj);

    res.json(obj);
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

    const obj = task.toObject();
    obj.status = computeStatus(obj);

    res.json(obj);
  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};