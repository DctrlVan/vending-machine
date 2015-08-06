#Get the raw data passed in by walletnotify.sh
transaction = JSON.parse process.argv[2]
transaction['date'] = new Date()

# post data to the listening port
paymentUrl = 'http://localhost:8888/payment'
request = require 'request'
for out in transaction.vout
  request.post paymentUrl
    .form
      txid:transaction.txid
      address:out.scriptPubKey.addresses[0]
      btc:out.value
###
Example transaction passed to this file:
{ txid: '18b5c3a198d20a31417e925565bba974528d673858543719fa0e94431eb2f412',
  version: 1,
  locktime: 402,
  vin:
   [ { txid: '093f1ab7c4664966a6d6889318e9370cb65b0a8929a5d1b3d52b45613211e399',
       vout: 0,
       scriptSig: [Object],
       sequence: 4294967294 } ],
  vout:
   [ { value: 1, n: 0, scriptPubKey: [Object] },
     { value: 0.9999887, n: 1, scriptPubKey: [Object] } ],
  date: Fri Jul 17 2015 15:19:57 GMT-0700 (PDT) }
{ txid: '18b5c3a198d20a31417e925565bba974528d673858543719fa0e94431eb2f412',
  version: 1,
  locktime: 402,
  vin:
   [ { txid: '093f1ab7c4664966a6d6889318e9370cb65b0a8929a5d1b3d52b45613211e399',
       vout: 0,
       scriptSig: [Object],
       sequence: 4294967294 } ],
  vout:
   [ { value: 1, n: 0, scriptPubKey: [Object] },
     { value: 0.9999887, n: 1, scriptPubKey: [Object] } ],
  date: Fri Jul 17 2015 15:19:57 GMT-0700 (PDT) }

###
