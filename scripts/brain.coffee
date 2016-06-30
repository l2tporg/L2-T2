moment = require 'moment'

module.exports = (robot) ->
  key = 'sites'

  ### Add Function ###
  robot.hear /sc add (\S+) (\d+)$/, (msg) ->
#    messages = robot.brain.get('url') ? [] #２重登録を阻止?
    
    messages = robot.brain.get(key) ? []
    i = { url: msg.match[1], status: msg.match[2]}
    messages.push i
    robot.brain.set(key, messages)
    msg.send "added #{i.url}, #{i.status}"
#    robot.logger.info robot.brain.data
#
  ### Remove Function ###
  robot.hear /sc rm (\S+)$/, (msg) ->
    if removeSite(msg.match[1])
      msg.send "removed #{msg.match[1]}, #{msg.match[2]}"
    else
      msg.send "error: There are no such registered site."

  ### Update Function ###
  robot.hear /sc update (\S+) (\d+)$/, (msg) ->
    messages = robot.brain.get(key) ? []
    message = messages.map (i) ->
        "#{i.url} #{i.status}"
      .join '\n'
    msg.send message
    
  ### Get List Function ###
  robot.hear /sc list$/, (msg) ->
    messages = robot.brain.get(key) ? []
    message = messages.map (i) ->
        "#{i.url} #{i.status}"
      .join '\n'
    msg.send message
    
    
  ### Modules ###
  # remove
  removeSite = (siteName) ->
    data = getData()
#    robot.logger.info data
    for obj, key in data
#      console.log key
#      console.log obj
      if data[key]['url'] is siteName
        robot.brain.remove(key) #削除
        return true
      else
        return false
#    if data.url.siteName is undefined
#      return false
#    delete data.url.siteName #url: siteName
#    return true
  
  # getData
  getData = ->
#    data = robot.brain.get(key) ? []
    data = robot.brain.get(key) or {} #こちらでも良い
    return data
    
#  robot.hear /7d add (\S+)$/, (msg) ->
#    message = msg.match[1]
#    messages = robot.brain.get(key) ? []
#    i = { room: msg.envelope.room, at: moment().add(7, 'days'), message }
#    messages.push i
#    robot.brain.set(key, messages)
#    msg.send "#{i.at.format('YYYY-MM-DD HH:mm')} #{i.message}"
#
#  robot.hear /7d list$/, (msg) ->
#    robot.logger.info robot.brain.data #@@
#    
#    messages = robot.brain.get(key) ? []
#    message = messages.sort (a, b) ->
#      if a.at.isSame(b.at)
#        0
#      else if a.at.isBefore(b.at)
#        -1
#      else
#        1
#    .map (i) ->
#      "#{i.at.format('YYYY-MM-DD HH:mm')} #{i.message}"
#    .join '\n'
#    msg.send message

#  watch = ->
#    setTimeout ->
#      messages = robot.brain.get(key) ? []
#      now = moment()
#      targets = messages.filter (i) -> i.at.isBefore(now)
#      newMessages = messages.filter (i) -> !i.at.isBefore(now)
#      if messages.length isnt newMessages.length
#        robot.brain.set(key, newMessages)
#      targets.forEach (i) ->
#        robot.messageRoom i.room, i.message
#      watch()
#    , 60000
#
#  watch()