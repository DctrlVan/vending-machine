log = require './logger.coffee'

blockchain = require 'blockchain.info'
blockexplorer = blockchain.blockexplorer;

products = require './products.coffee'

productAddresses = []
for product in products
  log.info 'Watching:', product.address
  productAddresses.push product.address

checkUnconfirmed = (callback)->
  log.debug "Checking Unconfirmed Transactions from blockchain.info"
  blockexplorer.getUnconfirmedTx (err, txs)->
    log.debug "response recieved from blockexplorer"
    if err
      log.error 'Error from get Unconfirmed', err
      return callback null
    # loop through all unconfirmed transactions.
    if txs.txs?
      for transaction in txs.txs
        # loop through outputs of each transaction
        if transaction.out?
          for outDoc in transaction.out
            # check if it's an output address we care about
            if outDoc.addr? and  outDoc.addr? and outDoc.value?
              if outDoc.addr in productAddresses
                payment =
                  txid: transaction.hash
                  address: outDoc.addr
                  btc : outDoc.value / 100000000
                log.debug "Found payment" , payment
                return callback payment
    callback null

module.exports = (dispenser)->
  checkUnconfirmed  (payment)->
    dispenser payment


###
# callback(null,
#   txid:transaction.hash
#   address:outDoc.addr
#   value: outDoc.value
###
