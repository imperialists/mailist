#
# Utility tools
#

# Extract email address from "Firstname, Lastname" <email@addre.ss>
extractEmail = (user) ->
    email = user.match /<([a-z0-9\._-]+@[a-z0-9\.-]+)>/
    if email? and email[1]? then email[1] else ''


# Extract list of email addresses from list of names
extractEmails = (users) -> users.map (user) -> extractEmail user


# Extract username from username@domain.part
extractUsername = (email) -> email.replace /@[a-z0-9\.-]+$/, ''


# Extract lists of usernames from list of email addresses
extractUsernames = (emails) -> emails.map (email) -> extractUsername email
