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

Urls = require('./brainClass')

module.exports = (robot) ->
  ### tmp check ###
  robot.hear /sc sites/i, (msg) ->
    statusCheck(msg)

  ###status check function ###
  statusCheck = (msg) ->
    console.log "checking..." #@@
    urls = new Urls(robot)
    data = urls.getData()
    for obj, key in data #u: url, s:status
      robot.send {room: "bot"}, "#{obj.url} status:  #{obj.status}" #@@
      robot.emit 'healthcheck:url:error2', {url: obj.url, status: obj.status}

  ### Add Function ###
  robot.hear /sc add (\S+) (\d+)$/, (msg) ->
#    data = robot.brain.get('url') ? [] #２重登録を阻止?
    urls = new Urls(robot)
    data = urls.getData()
    url = msg.match[1]
    status = Number(msg.match[2])
    i = { url: url, status: status}
    if urls.checkConfliction(data, i.url) #重複検査, data内にi.urlが存在していなければtrue
      data.push i
      robot.brain.set(key, data)
      index = urls.searchIndex(data, "#{i.url}")
      msg.send "added #{index}: #{i.url}, #{i.status}"
#      robot.logger.info data
#      robot.logger.info i
    else
      msg.send "Such url had already been registered."

  ### Get List Function ###
  robot.hear /sc list$/, (msg) ->
    urls = new Urls(robot)
    data = urls.getData()
#    console.log msg
    message = data.map (i) ->
        "#{urls.searchIndex(data, i.url)}: #{i.url} #{i.status}"
      .join '\n'
    msg.send message

  ### Update Function ###
  robot.hear /sc update (\d+) (\d+)$/, (msg) ->
    urls = new Urls(robot)
    data = urls.getData()
#    data = updateSite msg.match[1], msg.match[2] #index, new_status
    if urls.updateSite msg.match[1], msg.match[2] #index, new_status
      msg.send "updated #{data[msg.match[1]].url}, #{data[msg.match[1]].status}"
    else
      msg.send "error: There are no such registered site."

  ### Remove Function ###
  robot.hear /sc remove (\d+)$/, (msg) ->
#    data.splice(msg.match[1],1) #0から1つ削除
#    msg.send "success"
#    robot.logger.info data
    urls = new Urls(robot)
    data = urls.removeSite msg.match[1]
    if data isnt false
      msg.send "removed #{data.url}, #{data.status}"
    else
      msg.send "error: There are no such registered site."