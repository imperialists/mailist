Server   = require '../server'
Adapter  = require '../adapter'
smtp     = require 'simplesmtp'

class Mail extends Adapter
    send: (user, message) ->
        # send
    
    run: ->
        @svr = smtp.createServer {
            name: 'maili.st'
            SMTPBanner: 'maili.st SMTP server'
        }
        @svr.listen conf.smtp_port, (err) ->
            @server.logger.error "SMTP Server error: #{err}" if err?

        @svr.on 'startData', (envelope) =>
            @server.logger.info "Mail from #{envelope.from}"
            envelope.content = ''

        @svr.on 'data', (envelope, chunk) =>
            envelope.content += chunk

        @svr.on 'dataReady', (envelope, callback) =>
            header, body = parser.parse_part envelope.content
            @receive new Server.Message envelope.from, envelope.to, header, body
            
        self.emit "connected"
        
        
exports.use = (server) ->
    new Mail server