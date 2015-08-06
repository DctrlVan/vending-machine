sqlite = require 'sqlite3'
db = new sqlite.Database 'log/logs.db'
###
This prepare format accepts three parameters.
Note that in both cases the timestamp is
added automatically by sqlite.
###
logPayment = db.prepare """
  INSERT INTO payments
  (txid,amt_btc,amt_cdn)
  VALUES
  (?,?,?)
  """
# test : success
logPayment.run "test #{Math.random()}", 1, 3, (e)->
  console.log "by ?s:" + e
  #no_error


# This prepare format accepts a document
# and should replace the $symbols,
# but it is not working :
# Error: SQLITE_RANGE: bind or column index out of range
logPayment2 = db.prepare """
  INSERT INTO payments
  (txid,amt_btc,amt_cdn)
  VALUES
  ($tx,$btc,$cdn)
  """
doc =
  tx:"sdsdsasdasdsd"
  btc:1234
  cdn:333
# test: fail
logPayment2.run doc, (e)->
  console.log "with doc:" + e
  #Error: SQLITE_RANGE: bind or column index out of range


logPayout = db.prepare """
  INSERT INTO payouts
  (txid,product)
  VALUES
  (?,?)
  """

module.exports = {logPayment, logPayout}
