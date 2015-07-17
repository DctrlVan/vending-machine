###
GET QUADRIGA AVERAGE EXCHANGE RATE CDN
###
avgCDNUrl = 'https://api.quadrigacx.com/v2/ticker'
request = require 'request'
getAvgCDN = (callback)->
  request avgCDNUrl,(err,res,body)->
    callback null, (JSON.parse body).vwap

module.exports = { getAvgCDN }
###
SAMPLE DATA RETURNED QUADRIGA:
vwap -> volume weighted average price
{
  "high": "375.00",
  "last": "364.42",
  "timestamp": "1437170314",
  "bid": "361.59",
  "vwap": "363.09",
  "volume": "280.78115031",
  "low": "357.94",
  "ask": "364.02"
}
###
