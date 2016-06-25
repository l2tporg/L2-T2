request = require('request')
module.exports = (robot) ->
  ### tmp check ###
  robot.hear /sc sites/i, (msg) ->
    statusCheck(msg)

  statusCheck = (msg) ->
    msg.send 'checking...'
    key = 'sites'
    
    ##adding 
#    messages = robot.brain.get(key) ? []
#    i = { url: "http://google.com", status: 200}
#    messages.push i
#    i = { url: "http://yahoo.co.jp", status: 200}
#    messages.push i
#    robot.brain.set(key, messages)
#    msg.send "added #{i.url}, #{i.status}"

    #getting
    urls = robot.brain.get(key) ? []
#    url = urls.map (i) ->
#        "#{i.url} #{i.status}"
#      .join '\n'
#
    robot.logger.info urls
    for valueObject, key in urls #u: url, s:status
      robot.send({room: "bot"}, 'key: '+key, 'url: '+ valueObject.url, 'staus: '+ valueObject.status)

#    for u, s in urls #u: url, s:status
#      robot.logger.info u, s #@@
      robot.emit 'healthcheck:url', {url: valueObject.url, status: valueObject.status}

#    robot.emit 'healthcheck:url', {url: 'https://www.google.com', status: 200}
#    robot.emit 'healthcheck:url', {url: 'http://takamachi.com/hogehoge', status: 200}
#    robot.emit 'healthcheck:url', {url: 'http://sasukene.info', status: 500}

  ###test module###
  test = ->

    messages = []
    key = 'sites'
    i = { url: 'www.google.com', status: 200}
    messages.push i
    i = { url: 'www.yahoo.co.jp', status: 200}
    messages.push i
    robot.logger.info messages
#    messages = [
#      hoge: {url: 'hoge.com'},
#      fuga: {url: 'fuga.com'}
#    ]

    for valueObject, key in messages #u: url, s:status
      robot.send({room: "bot"}, 'key: '+key, 'url: '+ valueObject.url, 'staus: '+ valueObject.status)
    # robot.logger.info key, value, key #@@

    process.exit()

    robot.brain.set(key, messages)
    urls = robot.brain.get(key) ? []
    robot.logger.info urls

    for value, key in urls #u: url, s:status
      robot.logger.info value, key #@@
      # robot.emit 'healthcheck:url', {url: u, status: s}

    # robot.send({room: "bot"}, 'hello')
    process.exit()

#  test()





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
    
    
