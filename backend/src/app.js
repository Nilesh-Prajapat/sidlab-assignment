const express = require("express");
const cors = require("cors");
const authRoutes = require("./routes/auth_route");
const taskRoutes = require("./routes/task_route");
const contactRoutes = require("./routes/contact_route");

const app = express();

app.use(cors());
app.use(express.json());
app.use("/api/auth", authRoutes);
app.use("/api/tasks", taskRoutes);
app.use("/api/contact", contactRoutes);

app.get("/", (req, res) => {
    res.json({ message: "Api up" });
});

module.exports = app;