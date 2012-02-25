# This is the maili.st Loading Bay. NPM uses it as an entry point.
#
#     Mailist = require 'mailist'
#     list = Mailist.server 'mail'

# Loads a Hubot robot
exports.load = (adapterPath, adapterName) ->
  server = require './src/server'
  new server adapterPath, adapterName

exports.server = ->
  require './src/server'

exports.adapter = ->
  require './src/adapter'