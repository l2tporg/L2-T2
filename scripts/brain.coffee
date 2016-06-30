moment = require 'moment'

module.exports = (robot) ->
  key = 'sites'

  ### Add Function ###
  robot.hear /sc add (\S+) (\d+)$/, (msg) ->
#    data = robot.brain.get('url') ? [] #２重登録を阻止?
    
    data = robot.brain.get(key) ? []
    i = { url: msg.match[1], status: msg.match[2]}
    data.push i
    robot.brain.set(key, data)
    msg.send "added #{i.url}, #{i.status}"
    robot.logger.info robot.brain.data
#
  ### Remove Function ###
  robot.hear /sc rm (\S+)$/, (msg) ->
    data = getData()
    data.splice(0,1) #0から1つ削除
    msg.send "success"
    robot.logger.info data
#    if removeSite msg.match[1]
#      msg.send "removed #{msg.match[1]}, #{msg.match[2]}"
#    else
#      msg.send "error: There are no such registered site."

  ### Update Function ###
  robot.hear /sc update (\S+) (\d+)$/, (msg) ->
    data = robot.brain.get(key) ? []
    message = data.map (i) ->
        "#{i.url} #{i.status}"
      .join '\n'
    msg.send message
    
  ### Get List Function ###
  robot.hear /sc list$/, (msg) ->
    data = robot.brain.get(key) ? []
    message = data.map (i) ->
        "#{i.url} #{i.status}"
      .join '\n'
    msg.send message
    
    
  ### Modules ###
  # remove
  removeSite = (siteName) ->
    data = getData()
#    robot.brain.data.todos ||= []
#    index = msg.match[1]
#    if index > (robot.brain.data.todos.length - 1)
#      return msg.send "index[#{index}]のTODOは存在しません"
#    delete robot.brain.data.todos.splice(index, 1)
#    msg.send "TODOリストから削除しました"

    robot.logger.info data
    for obj, key in data
      if data[key]['url'] == siteName
        break

    if key > data.length - 1
      return false
    robot.brain.remove(key) #削除
#    delete data[key]
    return true


  
  # getData
  getData = ->
#    data = robot.brain.get(key) ? []
    data = robot.brain.get(key) or {} #こちらでも良い
    return data
    
#  robot.hear /7d add (\S+)$/, (msg) ->
#    message = msg.match[1]
#    data = robot.brain.get(key) ? []
#    i = { room: msg.envelope.room, at: moment().add(7, 'days'), message }
#    data.push i
#    robot.brain.set(key, data)
#    msg.send "#{i.at.format('YYYY-MM-DD HH:mm')} #{i.message}"
#
#  robot.hear /7d list$/, (msg) ->
#    robot.logger.info robot.brain.data #@@
#    
#    data = robot.brain.get(key) ? []
#    message = data.sort (a, b) ->
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
#      data = robot.brain.get(key) ? []
#      now = moment()
#      targets = data.filter (i) -> i.at.isBefore(now)
#      newdata = data.filter (i) -> !i.at.isBefore(now)
#      if data.length isnt newdata.length
#        robot.brain.set(key, newdata)
#      targets.forEach (i) ->
#        robot.messageRoom i.room, i.message
#      watch()
#    , 60000
#
#  watch()