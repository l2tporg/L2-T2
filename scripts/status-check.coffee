request = require('request')
module.exports = (robot) ->
  ### tmp check ###
  robot.hear /sc sites/i, (msg) ->
    msg.send 'checking...'
    key = 'sites'
    urls = robot.brain.get(key) ? []
    url = urls.map (i) ->
        "#{i.url} #{i.status}"
      .join '\n'
    msg.send url
    msg.send urls.length
    msg.send urls[0]

    for u, s in urls #u: url, s:status
      robot.logger.info u, s #@@
      robot.emit 'healthcheck:url', {url: u, status: s}
#    robot.emit 'healthcheck:url', {url: 'https://www.google.com', status: 200}
#    robot.emit 'healthcheck:url', {url: 'http://takamachi.com/hogehoge', status: 200}
#    robot.emit 'healthcheck:url', {url: 'http://sasukene.info', status: 500}
#
  ### Event class ###
  robot.on 'healthcheck:url', (data) ->
      options = {
        url: data.url
        status: data.status
        headers: "User-Agent":"iPhone"
      }
      request.get options, (err, res, body) ->
#        robot.logger.info data.status
#        robot.logger.info options.url
#        robot.logger.info res.statusCode
        if err
#          robot.logger.error err
#          robot.send {room: "notifications"}, "error: #{res.statusCode}"
          robot.send {room: "bot"}, err
        else if res.statusCode is options.status
          msg = "#{options.url} : #{res.statusCode}"
          robot.send {room: "bot"}, msg + " All right :)"
        else if res.statusCode isnt options.status #doesn't matched
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
    
    
