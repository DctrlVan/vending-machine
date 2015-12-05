log = require './logger.coffee'
paymentUrl = 'http://localhost:8888/payment'
request = require 'request'

blockchain = require 'blockchain.info'
blockexplorer = blockchain.blockexplorer;

checkUnconfirmed = (address, callback)->
  blockexplorer.getUnconfirmedTx (err,txs)->
    if txs?
      for transaction in txs.txs
        for key,value of transaction
          if key=='out'
            for outDoc in value
              if outDoc.addr == address
                callback(null,
                  txid:transaction.hash
                  address:outDoc.addr
                  value: outDoc.value
                );


module.exports = ()->
  console.log "checking UTXO"
  checkUnconfirmed  "1x8tkeQaLRPRLHVt7LxagvTDoUDDKQZxb" , (err, payDoc)->
    console.log "requesting #{payDoc}"
    request.post paymentUrl
      .form
        txid:payDoc.txid
        address:payDoc.address
        btc:payDoc.value/100000000
