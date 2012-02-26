Thread = require '../models/Thread'

module.exports =
  index: (req, res) ->
    console.log 'index'
    res.render "index",
      title: "maili.st"

  getThreadsForLabel: (req, res) ->
    console.log 'getThreadsForLabel', req.params
    Thread.find { labels: { $in: [req.params.label] }}, (err, thread) ->
      res.json thread

