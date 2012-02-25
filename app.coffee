connect = require 'connect'
express = require 'express'
jade = require 'jade'

app = module.exports = express.createServer()

# CONFIGURATION
mongoose = require "mongoose"
app.configure(() ->
	app.set 'view engine', 'jade'
	app.set 'views', "#{__dirname}/views"
	
	app.use connect.bodyParser()
	app.use connect.static(__dirname + '/public')
	app.use express.cookieParser()
	app.use express.session({secret : "shhhhhhhhhhhhhh!"})
	app.use express.logger()
	app.use express.methodOverride()
	app.use app.router
)

app.configure 'development', () ->
	mongoose.connect 'mongodb://localhost/mailist-dev'
	app.use express.errorHandler({
		dumpExceptions: true
		showStack     : true
	})

app.configure 'production', () ->
	mongoose.connect 'mongodb://localhost/mailist-dev'
	app.use express.errorHandler()

# ROUTES

app.get '/', (req, res) ->
	res.render 'index',
		locals:
			title: 'Hello World!'
			
# SERVER
	
app.listen(3000)
console.log "Express server listening on port #{app.address().port}"