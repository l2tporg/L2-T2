# Description
#   ステータスチェックを行うイベント
#
# Author:
#   @sak39
#

request = require('request')

module.exports = (robot) ->
  ### Satus Check class ###
  robot.on 'healthcheck:url', (data) ->
    options = {
      url: data.url
      status: data.status
      headers: "User-Agent":"iPhone"
    }
    request.get options, (err, res, body) ->
      if err
#          robot.logger.error err
#          robot.send {room: "notifications"}, "error: #{res.statusCode}"
        robot.send {room: "bot"}, err
      else if res.statusCode is data.status
        msg = "#{options.url} : #{res.statusCode}"
        robot.send {room: "bot"}, msg + " All right :)"
      else if res.statusCode isnt data.status #doesn't matched
#          robot.logger.error err
        msg = "#{options.url} : #{res.statusCode}"
        robot.send {room: "bot"}, msg + " Something wrong :("
#        else if res.statusCode isnt 200 #!200
##          robot.logger.error res.headers
##          robot.send {room: "bot"}, "success: #{res.statusCode}"
#          msg = "#{options.url} : #{res.statusCode}"
#          robot.send {room: "bot"}, msg
##          robot.send {room: "bot"}, "warning: Cannot arrive this server"
#        else if res.statusCode == 200 #Success
##          robot.logger.error res.headers
##          robot.send {room: "bot"}, "success: #{res.statusCode}"
#          msg = "#{options.url} : #{res.statusCode}"
#          robot.send {room: "bot"}, msg
  ### Satus Check class ###
  ### Only sending error message ###
  robot.on 'healthcheck:url:error', (data) ->
    options = {
      url: data.url
      headers: "User-Agent":"iPhone"
    }
#    console.log "options: #{data.status}"
    #bodyは転送量が多いため省略
    request.get options, (err, res) ->
#      console.log res
      if err
        robot.send {room: "bot"}, err
      else if res.statusCode is data.status #do nothing
        console.log "res: #{res.statusCode}"
        console.log "Success! The site is alive."
      else if res.statusCode isnt data.status #send msg in case of unmatched
        console.log "res: #{res.statusCode}"
        console.log "unmatched"
        msg = "#{options.url}: [expected] #{data.status}, [actual] #{res.statusCode}"
        robot.send {room: "bot"}, msg + " Something wrong :("

        
  ### Only sending error message ver.2###
  robot.on 'healthcheck:url:error2', (data) ->
    options = {
      url: data.url
    }
#    console.log "data: #{data.url}, #{data.status}" #@@
    request.get options, (err, res, body) ->
      if err?
        robot.send {room: "bot"}, "Error: \"#{data.url}\" Connection fail."
      else
        ###想定値と一致するときは無言###
        if res.statusCode isnt data.status #想定値と異なる時のみ通知(l2-t2の仕様は、200に限らない)
          robot.send {room: "bot"}, "ERROR: #{data.url} [expect]: #{data.status}, [actual]: #{res.statusCode}"
