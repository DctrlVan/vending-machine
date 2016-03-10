
teller = require './teller.coffee'
log = require('./logger.coffee')
blockchaininfo = require './blockchainInfo.coffee'

log.info ':::starting up:::'
process.on 'uncaughtException', (err)-> log.error err

###
# Keep exchange rate up to date.
###

exchange = require './quadrigacx.coffee'
CDNtoBTC = 0
setRate = (err,rate)->   #this is callback function
  return log.error "setting rate error: #{err}" if err?
  CDNtoBTC = rate
  log.info "Rate updated: $#{rate}/btc"

# Get rate on startup
exchange.getAvgCDN setRate
#update exchange rate every~~ 2 hours
setInterval exchange.getAvgCDN, 7777777, setRate

# dispense function is callback to utxo search, passes payment doc and rate to teller.
dispense = (payment)-> teller payment , CDNtoBTC

# poll the unconfirmed transaction set:
setInterval blockchaininfo, 15000, dispense
