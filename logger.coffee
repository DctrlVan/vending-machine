# Text logs:
winston = require 'winston'

textFormat = (args)->
  l = args.message.length
  spaces= ""
  while l < 55
    spaces+=" "
    l++
  args.message + spaces + Date()

textLogger = new winston.Logger
  transports: [
    new winston.transports.Console
      json:false
      formatter:textFormat
    new winston.transports.File
      filename: __dirname + "/logs.txt"
      json:false
      formatter:textFormat
  ]

module.exports = textLogger
