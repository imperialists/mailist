# 
# Custom SMTP server for mailist
#

smtp     = require 'simplesmtp'
mongoose = require 'mongoose'
conf     = require '../conf/development.json'
parser   = require './parser'
utils    = require './lib/utils.coffee'
Message  = require '../models/Message'

# ----- Init -----

mongoose.connect conf.mongodb_uri
svr = smtp.createServer {
    name: 'maili.st'
    SMTPBanner: 'maili.st SMTP server'
}
svr.listen conf.smtp_port, (err) ->
    if err?
        console.log 'Unable to start SMTP Server: ' + err
    else
        console.log 'SMTP Server listening on port ' + conf.smtp_port

# ----- Event handlers -----

svr.on 'startData', (envelope) ->
    # envelope = 
    #   from: 'sender@example.com',
    #   to: [ 'label1@example.com', 'label2@example.com' ],
    #
    # TODO: (1) Process the to-addresses for 'label'
    console.log "From: " + envelope.from
    console.log "To (labels): " + envelope.to
    envelope.content = ''
    # TODO: (2) Prepare a MongoDB destination to write mail body


svr.on 'data', (envelope, chunk) ->
    # TODO: (1a) Parse 'In-reply-to: message-id' to identify thread parent
    # TODO: (1b) Parse custom header to identify thread parent
    # TODO: (2) Put data into MongoDB database
    console.log "Data: " + chunk
    envelope.content += chunk


svr.on 'dataReady', (envelope, callback) ->
    # TODO: (1) Close MongoDB connection
    # TODO: (2) Use callback(null, queue_id) to notify client
    # TODO: (3) Trigger bouncing of email to subscribers
    content = parser.parse_part envelope.content
    message =
        from: envelope.from
        to: envelope.to
        header: content.header
        body: content.body
    console.log message
    console.log 'Label: ' +  (utils.extractUsernames utils.extractEmails message.to)
    #console.log content
    console.log envelope.content
    callback null, 'QUEUE-ID'
    console.log "Email received"
