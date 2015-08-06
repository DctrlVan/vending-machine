sqlite = require 'sqlite3'
db = new sqlite.Database 'log/logs.db'

###TODO:Define stats queries###
getMonthlyTotals = db.prepare """
  SELECT btc_amt FROM payments
  ...
  """

getMonthlyTotals.run null, (err,results)->
  console.log err, results
