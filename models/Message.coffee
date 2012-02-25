mongoose = require 'mongoose'

Message = new mongoose.Schema(
  subject: String
  body: String
)

module.exports = mongoose.model 'Message', Message