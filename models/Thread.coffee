mongoose = require 'mongoose'
Message = require './Message'

Thread = new mongoose.Schema(
  messages: [Message]
  labels: [String]
)

module.exports = mongoose.model 'Thread', Thread
