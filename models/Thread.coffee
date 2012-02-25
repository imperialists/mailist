mongoose = require 'mongoose'

Thread = new mongoose.Schema(
  title: String
  body: String
)

module.exports = mongoose.model 'Thread', Thread