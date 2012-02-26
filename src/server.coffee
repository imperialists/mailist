Fs         = require 'fs'
Url        = require 'url'
Log        = require 'log'
Path       = require 'path'
Connect    = require 'connect'

utils      = require './lib/utils'

mongoose   = require "mongoose"
Message     = require '../models/Message'
Thread     = require '../models/Thread'

DEFAULT_ADAPTERS = [ 'smtp' ]

class Server
    constructor: (adapterPath, adapter) ->
        @adapter = null
        @logger = new Log process.env.LOG_LEVEL or 'info'
        @loadAdapter adapterPath, adapter if adapter?
        @db = mongoose.connect 'mongodb://localhost/mailist-dev'
	
    # Load the adapter Maili.st is going to use.
    #
    # path    - A String of the path to adapter if local.
    # adapter - A String of the adapter name to use.
    #
    # Returns nothing.
    loadAdapter: (path, adapter) ->
        @logger.debug "Loading adapter #{adapter}"
        try
            path = if adapter in DEFAULT_ADAPTERS
                "#{path}/#{adapter}"
            else
                "mailist-#{adapter}"
            
            @adapter = require("#{path}").use(@)
        catch err
            @logger.error "Cannot load adapter #{adapter}: #{err}"
        
    # Public: Passes the given message to any interested Listeners.
    #
    # message - A Server.Message instance.
    #
    # Returns nothing.
    receive: (message) ->
        labels = utils.extractUsernames utils.extractEmails(message.header.to.value.split ',')
        console.log labels
        
        message = new Message
            subject: message.subject
            sender: message.sender
            body: message.body
        
        if id = message.header['in-reply-to']?
            Thread.findOne { 'messages.id': id }, (err, thread) ->
                thread.messages.push message
                
                User.find { pins: thread.id }, (err, users) ->
                    @send(user, message) for user in users
        else
            thread = new Thread
                labels: labels
                messages: [ message ]
            thread.save (err) ->
                @logger.error "Cannot create new thread: #{err}" if err?
        
                User.find { 'subscriptions': { $in: labels } }, (err, users) ->
                    @send(user, message) for user in users
            
        
        
        Thread.find { 'labels': { $in: labels } }, (err, docs) ->
            console.log docs
	    #Thread.where('labels').in(labels).run (err, docs) ->
        #    console.log docs
        #for listener in @listeners
        #try
        #    results.push listener.call(message)
        #    break if message.done
        #catch ex
        #    @logger.error "Unable to call the listener: #{ex}"
        #    false
        #if message not instanceof Robot.CatchAllMessage and results.indexOf(true) is -1
        #@receive new Robot.CatchAllMessage(message)
    
    send: (user, message) ->
        @adapter.send user, message
    
    # Kick off the event loop for the adapter
    #
    # Returns: Nothing.    
    run: ->
        @adapter.run()
        
class Server.Message
    constructor: (@header, @body) ->
	
module.exports = Server