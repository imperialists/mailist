# 
# Custom SMTP server for mailist
#

smtp     = require 'simplesmtp'
mongoose = require 'mongoose'
conf     = require '../conf/development.json'

# ----- Init -----

mongoose.connect conf.mongodb_uri
svr = smtp.createServer {
    name: 'maili.st'
    secureConnection: yes
    SMTPBanner: 'maili.st SMTP server'
}
svr.listen 25
console.log 'SMTP Server listening on port 25'

# ----- Event handlers -----

svr.on 'startData', (envelope) ->
    # envelope = 
    #   from: 'sender@example.com',
    #   to: [ 'label1@example.com', 'label2@example.com' ],
    #
    # TODO: (1) Process the to-addresses for 'label'
    console.log "From: " + envelope.from
    console.log "To (labels): " + envelope.to
    # TODO: (2) Prepare a Mongol destination to write mail body

svr.on 'data', (envelope, chunk) ->
    # TODO: (1a) Parse 'In-reply-to: message-id' to identify thread parent
    # TODO: (1b) Parse custom header to identify thread parent
    # TODO: (2) Put data into Mongol database
    console.log "Data: " + chunk

svr.on 'dataReady', (envelope, callback) ->
    # TODO: (1) Close MongolDB connection
    # TODO: (2) Use callback(null, queue_id) to notify client
    # TODO: (3) Trigger bouncing of email to subscribers
    console.log "Email received"
