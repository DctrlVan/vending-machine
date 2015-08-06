###
Run this file to configure a new database.
###


sqlite = require 'sqlite3'
db = new sqlite.Database 'log/logs.db'

db.serialize ->
  db.run """
    CREATE TABLE payments
    (
    txid         TEXT           PRIMARY KEY,
    amt_btc      INTEGER        NOT NULL,
    amt_cdn      INTEGER        NOT NULL,
    timestamp    TEXT           DEFAULT CURRENT_TIMESTAMP
    ) """

  db.run """
    CREATE TABLE payouts
    (
    txid         TEXT,
    product      TEXT,
    timestamp    TEXT           DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(txid) REFERENCES payments(txid)
    ) """
