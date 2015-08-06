#!/bin/bash
dir=/home/pi/bbtm
log=$dir/log/transactions.txt
echo transaction-id:${1} >> ${log}
payment_script=$dir/transaction.coffee
raw_trans=`echo $(bitcoin-cli -regtest decoderawtransaction $(bitcoin-cli -regtest getrawtransaction ${1}))`
transaction=`echo $raw_trans|sed  's/ //g'`
coffee $payment_script $transaction
