#gpio = require('onoff').Gpio
log = require './logger.coffee'
products = require './products.coffee'

inUse = no
payed_txid = []

###
# Product data stores the price, trigger, que and pin for each
# available product with the recieving btc address as the key.
###
productData = {}
for product in products
  productData[product.address] =
    price:product.price
    floatTrigger:product.price - 5
    que:0
    gpioPin:product.gpioPin
  log.info "Enabled #{product.name} on #{product.address} for $#{product.price / 100}"

###
# Dispense product by pin
# Note the pin is dynamic so if we set the machine to automatically dispense;
# different pins can dispense different products.
###
dispense = (pin)->
  log.info "dispensed with pin:#{pin}"
  ###
  # The beered variable represents an 'out' pin on the raspberry pi.
  # When we write 1 to the pin it is on (light flashing, button active)
  ###
  ###
  beered = new gpio(pin,'out')
  beered.write 1, (err)->
    if err? then log.info err
    setTimeout ->
      beered.write 0
    , 2222
  ###
###
# que function handles the timing of the payouts. Ensures payments at the same time
# are handled, and the bulk ('rounds') are dispensed one at a time.
###
que = (address)->
  if inUse
    log.info "Machine busy, delaying payout for address #{address}"
    setTimeout ->
      que(address)
    , 15555
    return # exit que, wait for next call

  inUse = yes
  i = 0
  while productData[address].que > 0
    productData[address].que -= 1
    setTimeout ->
      dispense(productData[address].gpioPin)
    , 12345*i
    i += 1

  setTimeout ->
    log.info "Payout Complete:::new trigger #{productData[address].floatTrigger} cents"
    inUse = no1
  , 12345*i

###
# Pay function is exposed when teller is required, handles the payment processing.
###
module.exports = pay = (payment,exRate)->
  log.info "Checking payment #{payment.btc}btc to #{payment.address}"
  # If paid to an address we care about & not already paid:
  if productData[payment.address]? and payment.txid not in payed_txid
    log.info "Recieved #{payment.btc}btc to #{payment.address}"
    payed_txid.push payment.txid

    # payment reduces trigger value, if the trigger value is negative now this triggers dispense
    productData[payment.address].floatTrigger -= parseInt payment.btc*exRate*100

    while productData[payment.address].floatTrigger <= 0
      # while loop iterates the trigger up by the price and adds to the que each time.
      # this is what handles multiple purchases in a single transaction.
      productData[payment.address].floatTrigger += productData[payment.address].price
      productData[payment.address].que += 1

      # on the last loop we pass to the que function which handles dispensing.
      # Note that the floating trigger is dynamic so if you underpay by a bit, the next bit
      # to this address will trigger the payout.
      if productData[payment.address].floatTrigger >= 0
        que(payment.address)


###
# Another attempted explaination of pay and que functions :::
# -
# - log the transaction id in payed_tx (to prevent double payouts)
# - payment reduces trigger by value of payment.
# - From this reduced value, iterate up by the price
#     e.g. current trigger price $3,
#          $10 paid. -- new value negative $7
#          Negative 7 is passed to while loop which iterates up by the price:
#          -7 -(1)> -4 -(2)> -1 -(3)> 2 ---Two is the new trigger (remembers overpayment)
#          Three loops will trigger three payouts (stored in .que variable)
#
# - On the last loop call que function.
# - Que checks if the teller is in use, if so it delays the call.
# - Otherwise it sets timed callbacks to trigger the payouts (every 12 seconds)
# - after 12 seconds per payout the teller inUse is returned to false
###
