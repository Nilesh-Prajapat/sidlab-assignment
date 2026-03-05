require("dotenv").config();

const app = require("./app");
const connect_db = require("./config/db");
const PORT = process.env.PORT;

connect_db();

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

// i just kept it to test offline mode as i deployed but it was not working for some reason.