###
This file listens for communication from Bitcoind
It stores the exchange rate info.
###
teller = require './teller.coffee'
###
Log to log file, and console
###
logger = require('./log/logger.coffee').textLogger

logger.info ':::starting up:::'
###
Keep exchange rate up to date by
periodically asking quadriga.
###

exchange = require './quadrigacx.coffee'
CDNtoBTC = 0
setRate = (err,rate)->   #this is callback function
  if err
    logger.info "setting rate error: #{err}"
    CDNtoBTC = 380
  CDNtoBTC = rate
  logger.info "Rate updated: $#{rate}/btc"
exchange.getAvgCDN setRate
setInterval exchange.getAvgCDN, 7777777, setRate #update every~~ 2 hours

###
Ready a port to listen for payment details from the transaction script.
The transaction script is called by walletnotify.sh,
which is called by bitcoind when the wallet recieves btc
###

blockchaininfo = require './blockchainInfo.coffee'
server = require('express')()
parser = require 'body-parser'
server.use parser.urlencoded({extended:true}) #req.body->json object
server.listen 8888, (err)->
  logger.info "node server hwaiting"
  setInterval blockchaininfo, 15000
  server.post '/payment', (req,res)->
    res.sendStatus 200
    payment = req.body
    console.log "passing to teller"
    teller.pay payment, CDNtoBTC
