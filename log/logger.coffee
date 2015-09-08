


winston = require 'winston'

textFormat = (args)->
  args.message + "    |    " + Date()

textLogger = new winston.Logger
  transports: [
    new winston.transports.Console
      json:false
      formatter:textFormat
    new winston.transports.File
      filename:"log/winston.log"
      json:false
      formatter:textFormat
  ]

#sq = require "sqlite3"
#db = new sq.Database("log/log.db")

module.exports = { textLogger }
