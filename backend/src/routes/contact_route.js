const express = require("express");
const router = express.Router();

const { createContact } = require("../controllers/contact_controller");

router.post("/", createContact);

module.exports = router;