mongoose = require "mongoose"
Thread = require '../models/Thread'

module.exports =
  index: (req, res) ->
    console.log 'index'
    res.render "index",
      title: "maili.st"

  getLabels: (req, res) ->
    console.log 'getLabels', req
    map = () ->
      if !this.labels
        return

      for label in this.labels
        emit(label, 1)

    reduce = (previous, current) ->
      count = 0

      for index in current
        count += index

      return count

    command = {
      mapreduce: "threads",
      map: map
      reduce: reduce
      sort: {label: 1},
      out: "labels"
    }
    mongoose.connection.db.executeDbCommand command, (err, dbres) ->
      console.log dbres
    mongoose.connection.db.collection 'labels', (err, collection) ->
      collection.find {}, (err, labels) ->
        res.json labels

  getThreadsForLabel: (req, res) ->
    console.log 'getThreadsForLabel', req.params
    Thread.find { labels: { $in: [req.params.label] }}, (err, thread) ->
      res.json thread

