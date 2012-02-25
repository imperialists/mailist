Server  = require './server'
event   = require 'events'

class Adapter extends event.EventEmitter
	# An adapter is a specific interface to message source for server
	#
	# server - A server instance.
	constructor: (@server) ->
	
	# Public: A method for sending message to user
	#
	# user    - A User instance.
	# message - A message to send.
	send: (user, message) ->
	
	# Public: Raw method for invoking the server to run
	# Extend this.
	run: ->
	
	# Public: Raw method for shutting the server down.
	# Extend this.
	close: ->
			

module.export = Adapter