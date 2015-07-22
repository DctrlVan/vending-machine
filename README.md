# Setup Instructions:

Install bitcoind.
Target the walletnotify.sh script in the bitcoin.conf file.

#### example /.bitcoin/bitcoin.conf:
rpcuser=bitcoinrpc
rpcpassword=EPas8odfh993fjdslihf329985kjfldkmfM5
minrelaytxfee=0.00005
limitfreerelay=5
walletnotify=/home/decentral/Code/bbtm/walletnotify.sh %s

The walletnotify.sh script also needs to be configured so the
dir is targeting current directory (but calling pwd does not
work because it is called by bitcoind)


#### Currently Not Connected to Pi
Beer function in teller should trigger gpio pins, but for now
just console.log the trigger.

## To test:
#### Run Port
`npm install coffee-script -g`
`npm install`
`coffee port.coffee`

#### Run Bitcoind and trigger transactions
`bitcoind -regtest -daemon`
`bitcoin-cli -regtest sendtoaddress mhGxDcqDTVZf5tM696RYSm7RhsyfSqM12h <btcvalue>`
