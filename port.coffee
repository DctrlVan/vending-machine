
teller = require './teller.coffee'
log = require('./logger.coffee')
blockchaininfo = require './blockchainInfo.coffee'

server = require('express')()
parser = require 'body-parser'
server.use parser.urlencoded({extended:true})

log.info ':::starting up:::'

###
Keep exchange rate up to date by
periodically asking quadriga.
###
exchange = require './quadrigacx.coffee'
CDNtoBTC = 0
setRate = (err,rate)->   #this is callback function
  return log.error "setting rate error: #{err}" if err?
  CDNtoBTC = rate
  log.info "Rate updated: $#{rate}/btc"

# Get rate on startup
exchange.getAvgCDN setRate

server.listen 8888, (err)->
  return log.error "Server error: #{err}" if err?
  log.info "node server hwaiting"

  ###
  # Intervals poll for exchange rate and transactions.
  ###
  setInterval exchange.getAvgCDN, 7777777, setRate #update exchange rate every~~ 2 hours
  setInterval blockchaininfo, 15000 # poll utxo every 15 seconds

  ###
  # Listen for payment on /payment, pass to teller pay function:
  ###
  server.post '/payment', (req,res)->  teller req.body, CDNtoBTC
