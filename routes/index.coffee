mongoose = require 'mongoose'
Thread   = require '../models/Thread'
User     = require '../models/User'

withUser = (callback) ->
    User.findOne (err, user) ->
        callback(user)
        

module.exports =
    index: (req, res) ->
        console.log 'index'
        res.render 'index',
            title: "maili.st"
    
    
    getPinnedThreads: (req, res) ->
        withUser (user) ->
            #user = req.session.user
            Thread.find { '_id': { $in: user.pins } }, (err, threads) ->
                res.json threads
    
    
    getPinThread: (req, res) ->
        withUser (user) ->
            #user = req.session.user
            Thread.findById req.params.thread, (err, thread) ->
                user.pins.push thread._id
                user.save (err) ->
                    console.log "Error while pinning thread" if err?
    
    
    getLabels: (req, res) ->
        map = ->
            emit(label, 1) for label in @labels

        reduce = (previous, current) ->
            count = 0
            for key, value of current
                count += value
            return count

        Thread.collection.mapReduce map.toString(), reduce.toString(), { out: 'labels' }, (err, val) ->
            console.log val if err?
        mongoose.connection.db.collection 'labels', (err, collection) ->
            collection.find().toArray (err, labels) ->
                res.json labels
    
    
    getThreadsForLabel: (req, res) ->
        Thread.find { labels: { $in: [req.params.label] }}, (err, thread) ->
            res.json thread
    
    
    getSubscribedLabels: (req, res) ->
        withUser (user) ->
            #user = req.session.user
            res.json user.subscriptions
    
        
    subscribeToLabel: (req, res) ->
        withUser (user) ->
            #user = req.session.user
            user.subscriptions.push req.params.label
            user.save (err) ->
                console.log "Error while subscribing to label" if err?
        
        
    postNewMessage: (req, res) ->
        withUser (user) ->
            message = new Message(req.body.post)
            message.save (err) ->
                console.log "Error while saving message" if err?
                res.json message unless err?

                
    logout: (req, res) ->
        req.logout()
        res.redirect '/'
