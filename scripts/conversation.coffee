####
#User Local Inc.の自動会話APIを使った会話スクリプト
####
#module.exports = (robot) ->
#  robot.hear /location (.*)/, (msg) ->
#    request = robot.http("https://maps.googleapis.com/maps/api/geocode/json")
#                   .query(address: msg.match[1])
#                   .get()
#    request (err, res, body) ->
#      json = JSON.parse body
#      location = json['results'][0]['geometry']['location']
#
#      msg.send "#{location['lat']}, #{location['lng']}"
#
#  robot.respond /conv (.*)/i, (msg) ->
#    request = require('request')
##    en_msg = encodeURIComponent(mag.match[1])
##    console.log(en_msg)
#    request = robot.http("https://chatbot-api.userlocal.jp/api/chat")
#                   .query(message: msg)
#                   .get()
#    request (err, res, body) ->
#      json = JSON.parse(body)
##      message = json['result']
#
#      msg.send "#{json['result']}"
##
##robot.respond / (.*) /i, (res) ->
##  https://chatbot-api.userlocal.jp/api/chat?key=sample&message=
##おはよー
##  res.reply 'zzzzz'