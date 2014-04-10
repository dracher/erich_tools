
MongoClient = require('mongodb').MongoClient
format = require('util').format



MongoClient.connect('mongodb://localhost/igor_results',
(err, db) ->
  if err
    throw err

  console.log("Connect to Database")

  db.createCollection('')
)