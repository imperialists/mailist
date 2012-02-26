#
# Utility tools
#

# Extract list of email address from
#         list of "Firstname, Lastname" <email@addre.ss>
#
exports.extractEmails = (users) -> users.map (user) ->
    email = user.match /<([a-z0-9\._-]+@[a-z0-9\.-]+)>/
    email = user.match /([a-z0-9\._-]+@[a-z0-9\.-]+)/ unless email?
    if email? and email[1]? then email[1] else ''
    #email?[1] ? ''


# Extract lists of usernames from list of email addresses
#
exports.extractUsernames = (emails) -> emails.map (email) ->
    email.replace /@[a-z0-9\.-]+$/i, ''


# Queue Id (16-char upper case random string) generator
#
exports.generateQueueId = () ->
    s = ''
    s += Math.random().toString(36).substr(2).substr 0, 6
    s += '-'
    s += Math.random().toString(36).substr(2).substr 0, 6
    s += '-'
    s += Math.random().toString(36).substr(2).substr 0, 2
    s.toUpperCase() # Exim format: XXXXXX-YYYYYY-ZZ


# Generate an almost unique Message-ID (32-char timestamp+random string)
#
exports.generateMsgId = (senderEmail) ->
    uuid = require 'node-uuid'
    uuid.v1() + '@' + senderEmail.replace /^[a-z0-9\._-]+@/i, ''
