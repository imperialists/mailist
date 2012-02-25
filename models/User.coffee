mongoose = require 'mongoose'

User = new mongoose.Schema(
  name: String
  email: String
  password: String
  subscriptions: [String]
  pins: [mongoose.Schema.ObjectId]
)

module.exports = mongoose.model 'User', User
