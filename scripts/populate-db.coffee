mongoose = require "mongoose"
db = mongoose.connect 'mongodb://localhost/mailist-dev'	
Thread  = require '../models/Thread'
User    = require '../models/User'

message =
	subject: 'Friday cakes'
	sender: 'rumi.neykova@gmail.com'
    body: 'Eat & Enjoy'

thread = new Thread
    labels: ['notice-board']

thread.messages.push message
thread.save (err) ->
	console.log err if err?

user = new User
    name: 'Petr Hosek'
    email: 'p.hosek@imperial.ac.uk'
    password: 'hidden'
    subscriptions: ['notice-board']
    pins: ['4f49843500d896cc43000001']

user.save (err) ->
    console.log err if err?

console.log 'Done'