Fs         = require 'fs'
Url        = require 'url'
Log        = require 'log'
Path       = require 'path'
Connect    = require 'connect'

DEFAULT_ADAPTERS = [ 'smtp' ]

class Server
    constructor: (adapterPath, adapter) ->
        @adapter = null
        @logger = new Log process.env.LOG_LEVEL or 'info'
        @loadAdapter adapterPath, adapter if adapter?
	
    # Load the adapter Maili.st is going to use.
    #
    # path    - A String of the path to adapter if local.
    # adapter - A String of the adapter name to use.
    #
    # Returns nothing.
    @loadAdapter: ->
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
    # message - A Robot.Message instance. Listeners can flag this message as
    #  'done' to prevent further execution
    #
    # Returns nothing.
    receive: (message) ->
        results = []
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
        @adapter.run
        
class Server.Message
    constructor: (@user, @message) ->