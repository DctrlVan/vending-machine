# Vending Machine Code

File descriptions:
- *products.coffee* is a configuration file that describes the content, price and recieving btc address for vending.
- *vending-machine.coffee* initiates the intervals that watch the exchange rate and the unconfirmed transaction set.
- *blockchainInfo.coffee* watches the for new transactions in blockchain.info's utxo set.
- *quadrigacx.coffee* calls out to quadrigas exchange price api
- *teller.coffee* manages the dispense of the products.


#### Possible Improvement List:
- Add more services that watch the utxo set.
- Create a local network full node (bitcored is the likely candidate) to query for transactions.
- Watch for double-spends / confirm confirmations.
- Add web interface to allow purchase and reciept of vending tokens.
- Rig machine to dispense automatically.
