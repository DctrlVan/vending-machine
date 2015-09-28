paymentUrl = 'http://localhost:8888/payment'
request = require 'request'

blockchain = require 'blockchain.info'
blockexplorer = blockchain.blockexplorer;

checkUnconfirmed = (address, callback)->
  blockexplorer.getUnconfirmedTx (err,txs)->
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
  checkUnconfirmed  "16RyYkFi7fkqFD9KP6NdYcSsZj77EHABaf" , (err, payDoc)->
    console.log "requesting #{payDoc}"
    request.post paymentUrl
      .form
        txid:payDoc.txid
        address:payDoc.address
        btc:payDoc.value/100000000
