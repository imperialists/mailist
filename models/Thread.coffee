mongoose = require 'mongoose'
#Message = require './Message'

Message = new mongoose.Schema(
    id: String
    subject: String
    sender: String
    body: String
    sent: { type: Date, default: Date.now }
)

Message.path('subject').validate (val) ->
    val.length > 0
'Subject cannot be empty'

Thread = new mongoose.Schema(
    labels: [String]
    messages: [Message]
)
  
Thread.path('labels').validate (val) ->
    val.length > 0
'Thread has no labels'

module.exports = mongoose.model 'Thread', Thread
