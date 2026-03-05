require("dotenv").config();

const app = require("./app");
const connect_db = require("./config/db");
require("dotenv").config();
const PORT = process.env.PORT;

connect_db();

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});