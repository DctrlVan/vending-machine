# Text logs:
winston = require 'winston'

textFormat = (args)->
  args.message + "    |    " + Date()

textLogger = new winston.Logger
  transports: [
    new winston.transports.Console
      json:false
      formatter:textFormat
    new winston.transports.File
      filename:"/home/pi/log/logs.txt"
      json:false
      formatter:textFormat
  ]

module.exports = { textLogger }
