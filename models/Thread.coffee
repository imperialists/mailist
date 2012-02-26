mongoose = require 'mongoose'
Message = require './Message'


###Message = new mongoose.Schema(
  subject: String
  sender: String
  body: String
)###

Thread = new mongoose.Schema(
  labels: [String]
  messages: [Message])

module.exports = mongoose.model 'Thread', Thread

