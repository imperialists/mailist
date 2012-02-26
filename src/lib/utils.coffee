#
# Utility tools
#

# Extract list of email address from
#         list of "Firstname, Lastname" <email@addre.ss>
#
exports.extractEmails = (users) -> users.map (user) ->
    email = user.match /<([a-z0-9\._-]+@[a-z0-9\.-]+)>/
    email = user.match /([a-z0-9\._-]+@[a-z0-9\.-]+)/ unless email?
	email?[1] ? ''


# Extract lists of usernames from list of email addresses
#
exports.extractUsernames = (emails) -> emails.map (email) ->
    email.replace /@[a-z0-9\.-]+$/, ''


# Queue Id (16-char upper case random string) generator
#
exports.generateQueueId = (length=16) ->
    s = ''
    s += Math.random().toString(36).substr(2) while s.length < length
    (s.substr 0, length).toUpperCase()
