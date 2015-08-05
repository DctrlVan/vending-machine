### commented out until connected to pi ###
gpio = require('onoff').Gpio
### Utility / Config Variables ###

inUse = false
payed_txid = []

###
Look in the products config file,
create a holding variable to access by the btc address:
productData. This tracks the floating trigger and the pin
for each product
###
products = require './products.coffee'
productData = {}
for product in products
  productData[product.address] =
    price:product.price
    floatTrigger:product.price - 5
    que:0
    gpioPin:product.gpioPin

# change this to energize pi pin
count = 0
beer = (pin)->
  beered = new gpio(pin,'out')
  beered.write 1, (err)->
    if err? then console.log err
    setTimeout ->
      beered.write 0
    , 5000
###
  This is the place to implement tracking of inventory,
  Can include it on the productData object, but
  need to store figure out persistent storage
###
pay = (payment,exRate)->
  if productData[payment.address]?
    if ((payed_txid.indexOf payment.txid) == -1)
      payed_txid.push payment.txid
      productData[payment.address].floatTrigger -= parseInt payment.btc*exRate*100
      while productData[payment.address].floatTrigger <= 0
        productData[payment.address].floatTrigger += productData[payment.address].price
        productData[payment.address].que += 1
        if productData[payment.address].floatTrigger >= 0
          que(payment.address)

que = (address)->
  if inUse
    setTimeout ->
      que(address)
    , 15555
  else
    inUse = true
    if productData[address].que > 0
      beer(productData[address].gpioPin)
      productData[address].que -= 1
      i = 0
      while productData[address].que > 0
        i += 1
        productData[address].que -= 1
        setTimeout ->
          beer(productData[address].gpioPin)
        , 12345*i
      setTimeout ->
        console.log ":::Payout Complete:::"
        inUse = false
      , 12345*i

module.exports = {pay}

### Explaination of pay and que functions :::
- If paid to an address we care about & not already paid:
- log the transaction id in payed_tx (to prevent double payments)
- payment reduces trigger by value of payment.
- From this reduced value, iterate up by the price
    e.g. current trigger price $3,
         $10 paid. -- new value negative $7
         Negative 7 is passed to while loop which iterates up by the price:
         -7 -> -4 -> -1 -> 2 ---Two is the new trigger (remembers overpayment)
         Three loops will trigger three payouts (stored in .que variable)
- On the last loop call que function.
- Que checks if the teller is in use, if so it delays the call.
- Otherwise it sets timed callbacks to trigger the payouts (every 12 seconds)
- after 12 seconds per payout the teller inUse is returned to false
###
