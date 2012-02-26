mongoose = require 'mongoose'

User = new mongoose.Schema(
  name: String
  email: String
  password: String
  subscriptions: [String]
  pins: [{ type: mongoose.Schema.ObjectId, ref: 'Thread' }]
)

module.exports = mongoose.model 'User', User
