const express = require("express");
const cors = require("cors");
const authRoutes = require("./routes/auth_route");
const app = express();

app.use(cors());
app.use(express.json());
app.use("/api/auth", authRoutes);


app.get("/", (req, res) => {
    res.json({ message: "Api up" });
});

module.exports = app;