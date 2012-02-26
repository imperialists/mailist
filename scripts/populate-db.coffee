mongoose = require "mongoose"
db = mongoose.connect 'mongodb://localhost/mailist-dev'	
Thread  = require '../models/Thread'

message = {
	subject: 'Friday cakes'
	,sender: 'rumi.neykova@gmail.com'
    ,body: 'Eat & Enjoy'}

thread = new Thread
    labels: ['notice-board']

thread.messages.push message
thread.save()

console.log 'Ihu'