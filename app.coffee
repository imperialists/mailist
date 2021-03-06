connect = require 'connect'
express = require 'express'
jade = require 'jade'
routes = require './routes'
User = require './models/User'

app = module.exports = express.createServer()

# CONFIGURATION
mongoose = require "mongoose"
mongooseAuth = require 'mongoose-auth'
app.configure(() ->
    app.set 'view engine', 'jade'
    app.set 'views', "#{__dirname}/views"

    app.use connect.bodyParser()
    app.use connect.static(__dirname + '/public')
    app.use express.cookieParser()
    app.use express.session({secret : "shhhhhhhhhhhhhh!"})
    app.use mongooseAuth.middleware()
    app.use express.logger()
    app.use express.methodOverride()
    app.use app.router
)

app.configure 'development', () ->
    conf = require './conf/development.json'
    mongoose.connect conf.mongodb_uri
    app.use express.errorHandler({
    	dumpExceptions: true
    	showStack     : true
    })

app.configure 'production', () ->
    conf = require './conf/production.json'
    mongoose.connect conf.mongodb_uri
    app.use express.errorHandler()

# ROUTES

app.get '/', routes.index
app.get '/pinned', routes.getPinnedThreads
app.get '/pin/:thread', routes.getPinThread
app.get '/labels', routes.getLabels
app.get '/threads/:label', routes.getThreadsForLabel
app.get '/subscribed', routes.getSubscribedLabels
app.get '/subscribe/:label', routes.subscribeToLabel
app.post '/message/new', routes.postNewMessage
app.get '/logout', routes.logout

# SERVER

mongooseAuth.helpExpress(app)

app.listen(3000)
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
