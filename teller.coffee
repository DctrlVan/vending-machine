### commented out until connected to pi ###
#gpio = require('onoff').Gpio
#beered = new gpio(11,'out')
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
    gpioPin:product.gpioPin
    price:product.price
    floatTrigger:product.price - 5
    que:0

# change this to energize pi pin
beer = (pin)->
  console.log "beered:#{pin}"
  ### commented out until connected to pi
  beered.write 1, (err)->
    setTimeout ->
      beered.write 0
    , 5000
  This is the place to implement tracking of inventory,
  Probably can include it on the productData object, but
  need to store in persistent memory so inentory levels
  are not reset on reset.
  ###

pay = (payment,exRate)->
  # if not already paid, and paid to an address we care about:
  if productData[payment.address]?
    if payed_txid.indexOf payment.txid == -1
      payed_txid.push payment.txid
      productData[payment.address].floatTrigger -= parseInt payment.btc*exRate*100
      while productData[payment.address].floatTrigger <= 0
        productData[payment.address].floatTrigger += productData[payment.address].price
        productData[payment.address].que += 1
        if productData[payment.address].floatTrigger >= 0
          queBeer(payment.address)

queBeer = (address)->
  if inUse
    setTimeout ->
      queBeer(address)
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
        inUse = false
      , 12345*i

module.exports = {pay}
