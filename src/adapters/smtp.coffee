Server   = require '../server'
Adapter  = require '../adapter'

event   = require 'events'
smtp     = require 'simplesmtp'

parser   = require '../parser'

class SMTP extends event.EventEmitter
    constructor: (@server) ->
        
    send: (user, message) ->
        client = smtp.connect(25)
    
    receive: (message) ->
        @server.receive message
    
    run: ->
        self = @
        options =
            port: process.env.SMTP_PORT
        
        process.on "uncaughtException", (err) =>
            @server.logger.error "#{err}"
        
        @svr = smtp.createServer {
            name: 'maili.st'
            SMTPBanner: 'maili.st Server'
        }
        @svr.listen 25, (err) =>
            @server.logger.error "SMTP Server error: #{err}" if err?

        @svr.on 'startData', (envelope) =>
            @server.logger.info "Mail from #{envelope.from}"
            envelope.content = ''

        @svr.on 'data', (envelope, chunk) =>
            envelope.content += chunk

        @svr.on 'dataReady', (envelope, callback) =>
            { header, body } = parser.parseMail envelope.content
            callback null, 'QUEUE-ID'
            @receive new Server.Message header, body
            
        #self.emit "connected"
        
        
exports.use = (server) ->
    new SMTP server