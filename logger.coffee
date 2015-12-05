# Text logs:
winston = require 'winston'

textFormat = (args)->
  l = args.message.length
  spaces= ""
  while l < 55
    spaces+=" "
    l++
  date = Date()
  date = date[16..24] + date[0..9]
  args.message + spaces + date

textLogger = new winston.Logger
  transports: [
    new winston.transports.Console
      json:false
      formatter:textFormat
    new winston.transports.File
      name: 'overview'
      filename: __dirname + "/logs/logs.txt"
      json:false
      formatter:textFormat
      level:'info'
    new winston.transports.File
      name: 'details'
      filename: __dirname + "/logs/debug.txt"
      json:true
      level:'debug'
  ]

module.exports = textLogger
