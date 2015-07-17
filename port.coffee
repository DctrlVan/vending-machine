###
This file listens for communication from Bitcoind
It stores the exchange rate info.
It converts the payment to a cdn value then passes
to teller.
Teller manages the product payouts & inventory levels
###
teller = require './teller.coffee'

###
Log to log file, and console
###
logger = require 'winston'
logger.add logger.transports.File, filename: './log/main.log'
logger.info ':::starting up:::'

###
Keep exchange rate up to date by
periodically asking quadriga.
###
exchange = require './quadrigacx.coffee'
CDNtoBTC = 0
setRate = (err,rate)->   #this is callback function
  CDNtoBTC = rate
  logger.info "Rate updated: $#{rate}/btc"
setInterval exchange.getAvgCDN(setRate), 777777 #update every~~13 minutes

###
Ready a port to listen for payment details from the transaction script.
The transaction script is called by walletnotify.sh,
which is called by bitcoind when the wallet recieves btc
###

server = require('express')()
parser = require 'body-parser'
server.use parser.urlencoded({extended:true}) #req.body->json object
server.listen 8888, (err)->
  logger.info "listening 8888"
  server.post '/payment', (req,res)->
    res.send 'thanks'
    logger.info "payment: #{req.body}"
    payment = req.body
    logger.info "pay #{payment.btc}btc to #{payment.address}"
    teller.pay payment, CDNtoBTC, (err)->
