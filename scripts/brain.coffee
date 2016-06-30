moment = require 'moment'
_ = require 'underscore'
__ = require 'lodash'

module.exports = (robot) ->
  key = 'sites'

  ### Add Function ###
  robot.hear /sc add (\S+) (\d+)$/, (msg) ->
#    data = robot.brain.get('url') ? [] #２重登録を阻止?
    
    data = robot.brain.get(key) ? []
    i = { url: msg.match[1], status: msg.match[2]}
    data.push i
    robot.brain.set(key, data)
    index = searchIndex(data, "#{i.url}")
    msg.send "added #{index}: #{i.url}, #{i.status}"
    robot.logger.info data
    robot.logger.info i

  ### Remove Function ###
  robot.hear /sc rm (\d+)$/, (msg) ->
#    data.splice(msg.match[1],1) #0から1つ削除
#    msg.send "success"
#    robot.logger.info data
    data = removeSite msg.match[1]
    if data isnt false
      msg.send "removed #{data.url}, #{data.status}"
    else
      msg.send "error: There are no such registered site."

  ### Update Function ###
  ### command: sc update <index> <new_satus> ###
  robot.hear /sc update (\d+) (\d+)$/, (msg) ->
    data = getData()
    if updateSite msg.match[1], msg.match[2] #index, new_status
      msg.send "updated #{data.url}, #{data.status}"
    else
      msg.send "error: There are no such registered site."

  ### Get List Function ###
  robot.hear /sc list$/, (msg) ->
    data = robot.brain.get(key) ? []
    message = data.map (i) ->
        "#{searchIndex(data, i.url)}: #{i.url} #{i.status}"
      .join '\n'
    msg.send message
    
    
  ###### Modules #######
  # getData
  getData = ->
#    data = robot.brain.get(key) ? []
    data = robot.brain.get(key) or {} #こちらでも良い
    return data
  
  ### Remove ###
  removeSite = (index) ->
    data = getData()
    ### エラーチェック(範囲外判定) ###
    if index > (__.size(data) - 1)
      return false
    ###上手くいかない###
#    if index > (data.length - 1)
#      console.log data.length
#      return false
    ### 最後の出力に使う###
    tmp = {url: data[index].url, status: data[index].status} #避難
    ### indexから1つ削除 ###
    data.splice(index, 1) 
    return tmp

  ### Update ###
  updateSite = (index, newStatus) ->
    data = getData()
    if index > (__.size(data) - 1)
      return false
    data[index].status = newStatus
    return true

  #Search Index of HashArray
  searchIndex = (obj, key) ->
    new_obj = _.pluck(obj, 'url')
    index = new_obj.indexOf(key)
    if index > -1
      return index
    else
      return false
