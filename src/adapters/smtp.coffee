Server   = require '../server'
Adapter  = require '../adapter'

util     = require 'util'
event    = require 'events'
smtp     = require 'simplesmtp'
mail     = require 'mailcomposer'
email    = require 'emailjs'
msgUtils = require '../lib/utils'

parser   = require '../parser'

class SMTP extends event.EventEmitter
    constructor: (@server) ->
        
    send: (user, message) ->
        server = email.server.connect
            host: 'smarthost.cc.ic.ac.uk'
        server.send {
            from: message.sender
            to: user.email
            subject: message.subject
            text: message.body
        }, (err, message) ->
            @server.logger.error "Message send error #{err}" if err?

        return
        @client = smtp.connect 25, 'smarthost.cc.ic.ac.uk', name: 'maili.st'
        @client.once 'idle', =>
            console.log "#{message.sender} #{user.email}"
            @client.useEnvelope
                from: message.sender
                to: [ user.email ]
        @client.on 'rcptFailed', (addresses) =>
            @server.logger.error "The #{addresses} were rejected"
        @client.on 'message', =>
            mail = new MailComposer
                from: message.sender
                to: user.email
                body: message.body
            mail.streamMessage
            mail.pipe(@client)
        @client.on 'ready', (success, response) =>
            @server.logger.info "Message successfully sent #{response}"
            
    
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
            callback null, msgUtils.generateQueueId()
            @receive new Server.Message header, body
            
        self.emit "connected"
        
        
exports.use = (server) ->
    new SMTP server

class SMTPParser
	@trim: (string) ->
	    string.replace /^\s*|\s*$/, ""
        
    
	@explode: (string, delim, limit) ->
	    return string.split(delim) unless limit
	    parts = string.split(delim)
	    result = parts.slice(0, limit - 1)
	    result.push parts.slice(limit - 1).join(delim)
	    result


	@parse_header: (header) ->
	    result = {}
	    header = header.split(";")
	    result.value = trim(header[0])
    
	    for part in header[1..]
	        console.log part
	        continue if part is ""
	        tupple = explode(part, "=", 2)      
	        if tupple.length is 2
	            result[trim(tupple[0])] = trim(tupple[1]).replace(/^"/, "").replace(/"$/, "")
	        else
	            result[trim(tupple[0])] = ""
    
	    result
    
    
	@parse_header_block: (content) ->
	    result = {}
	    return result if content is ""
        
	    for header in content.split("\r\n")
	        tupple = explode(header, ":", 2)
	        if header.match /^\s+/ or tupple.length < 2
	            if key? and header.match /^\s+/
	                result[key] += " " + trim header
	            continue
	        key = tupple[0].toLowerCase()
	        result[key] = tupple[1]
    
	    for key of result
	        result[key] = parse_header result[key]
        
	    result
        
    
	@parse_body_block: (content, headers) ->
	    headers["content-type"] = value: "text/plain" unless headers["content-type"]
	    switch headers["content-type"].value
	        when "text/plain", "text/html"
	            return [
	                "content-type": "text/plain"
	                content: content
	            ]
	        when "multipart/mixed"
	            content = parse_multitype(content, headers["content-type"].boundary)
	        when "multipart/alternative"
	            content = parse_multitype(content, headers["content-type"].boundary)
	        when "image/png", "image/jpeg"
	            content = content.replace(/\r\n/g, "")
	        else
        
	    content
        
        
	@parse_multitype: (content, boundary) ->
	    return false if not content or not boundary
	    content = content.split("--" + boundary + "\r\n")
        
	    for i in [0..content.length]
	        content[i] = parse_part(content[i])
        
	    content
        
        
	@parse: (content) ->
	    console.log content
	    content = explode(content, "\r\n\r\n", 2)
	    header = parse_header_block(content[0])
       
	    if content.length is 2
	        body = parse_body_block(content[1], header)
	    else
	        body = ""
            
	    header: header
	    body: body
