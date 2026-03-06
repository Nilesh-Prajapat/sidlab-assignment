const mongoose = require("mongoose");

const taskSchema = new mongoose.Schema(
{
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true
  },

  title: {
    type: String,
    required: true
  },

  description: {
    type: String,
    default: ""
  },

  completed: {
    type: Boolean,
    default: false
  },

  dueDate: {
    type: Date,
    default: null
  },

  priority: {
    type: String,
    enum: ["LOW", "MEDIUM", "HIGH"],
    default: "MEDIUM"
  }

},
{
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});


// Virtual field for task status
taskSchema.virtual("status").get(function () {

  if (this.completed) return "DONE";

  if (this.dueDate && new Date() > new Date(this.dueDate)) {
    return "OVERDUE";
  }

  return "ACTIVE";
});

module.exports = mongoose.model("Task", taskSchema);