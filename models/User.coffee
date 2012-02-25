mongoose = require 'mongoose'

User = new mongoose.Schema(
  name: String
)

module.exports = mongoose.model 'User', User