mongoose = require 'mongoose'

Label = new mongoose.Schema(
  name: String
)

module.exports = mongoose.model 'Label', Label