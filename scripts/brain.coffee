# Description
#   検査対象のサイトのurl、statusCodeのCRUD処理
#
# Commands: [省略可能]:, <引数>
#   [l2-t2] add <url> <status> -- 検査するサイトを登録
#   [l2-t2] list -- 登録されたサイトをインデックス付きで表示
#   [l2-t2] update <index> <new_status> -- 登録されたサイトのインデックスと新しいステータスを指定して更新
#   [l2-t2] remove <index> -- 登録されたサイトをインデックスを指定して削除
#
# Author:
#   @sak39
#
# Thanks:
#   http://sota1235.hatenablog.com/entry/2015/06/15/001400

moment = require 'moment'
_ = require 'underscore'
__ = require 'lodash'

module.exports = (robot) ->
  key = 'sites'

  ### Add Function ###
  robot.hear /sc add (\S+) (\d+)$/, (msg) ->
#    data = robot.brain.get('url') ? [] #２重登録を阻止?
    
    data = getData()
    i = { url: msg.match[1], status: msg.match[2]}
    if checkConfliction(data, i.url) #重複検査, data内にi.urlが存在していなければtrue
      data.push i
      robot.brain.set(key, data)
      index = searchIndex(data, "#{i.url}") #正規の用法のsearchIndex
      msg.send "added #{index}: #{i.url}, #{i.status}"
      robot.logger.info data
      robot.logger.info i
    else
      msg.send "Such url had already been registered."
    
  ### Get List Function ###
  robot.hear /sc list$/, (msg) ->
    data = robot.brain.get(key) ? []
    message = data.map (i) ->
        "#{searchIndex(data, i.url)}: #{i.url} #{i.status}"
      .join '\n'
    msg.send message

  ### Update Function ###
  robot.hear /sc update (\d+) (\d+)$/, (msg) ->
    data = getData()
#    data = updateSite msg.match[1], msg.match[2] #index, new_status
    if updateSite msg.match[1], msg.match[2] #index, new_status
      msg.send "updated #{data[msg.match[1]].url}, #{data[msg.match[1]].status}"
    else
      msg.send "error: There are no such registered site."
    
  ### Remove Function ###
  robot.hear /sc remove (\d+)$/, (msg) ->
#    data.splice(msg.match[1],1) #0から1つ削除
#    msg.send "success"
#    robot.logger.info data
    data = removeSite msg.match[1]
    if data isnt false
      msg.send "removed #{data.url}, #{data.status}"
    else
      msg.send "error: There are no such registered site."

    
  ###### Modules #######
  # getData
  getData = ->
    data = robot.brain.get(key) ? []
#    data = robot.brain.get(key) or {} #ハッシュで管理する場合はこちら
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
  
  #Check elements conflisction
  checkConfliction = (obj, key) ->
    new_obj = _.pluck(obj, 'url')
    if not _.contains(new_obj, key)
      return true
    else
      return false
