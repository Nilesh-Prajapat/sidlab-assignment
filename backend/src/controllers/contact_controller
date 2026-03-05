const Contact = require("../models/contact");

exports.createContact = async (req, res) => {
  try {

    const { name, email, message } = req.body;

    const contact = await Contact.create({
      name,
      email,
      message
    });

    res.status(201).json({
      message: "Message received",
      contact
    });

  } catch (error) {
    res.status(500).json({ message: "Server error" });
  }
};