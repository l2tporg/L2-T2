# Description
#  hubot-site-health-examineを使ったサイト監視スクリプト
#
# Commands:
#  (l2-t2) she [examine|ex] - 監視メソッドを自発的に発火
#
# Author:
#   @sak39
#
# Thanks:
#   https://github.com/l2tporg/hubot-site-health-examine.git

Doctor = require('hubot-site-health-examine').Doctor
Nurse = require('hubot-site-health-examine').Nurse
cronJob = require('cron').CronJob

module.exports = (robot) ->
  console.log("statusCheck")
  doctor = new Doctor
  nurse = new Nurse(robot)
  flags = [1,0,1]

  ### 検査メソッドを自発的に発火 ###
  robot.hear /she ex(?:amine)?$/i, (msg) ->
    console.log "examing..." #@@
    list = nurse.getList()
    for site in list
      robot.emit 'healthExamine', site, flags, "bot"
  robot.hear /she examine/i, (msg) ->
    console.log "examing..." #@@
    list = nurse.getList()
    for site in list
      robot.emit 'healthExamine', site, flags, "bot"

  ###テスト用###
  ###hubot-servercチャネルに流す###
  robot.hear /she check/i, (msg) ->
    console.log "examing..." #@@
    list = nurse.getList()
    for site in list
      robot.emit 'healthExamine', site, flags, "20160623hubot-serverc"

  cronjob = new cronJob(
    cronTime: "1 * * * * *"     # 実行時間 s m h d w m
    start:    true              # すぐにcronのjobを実行するか
    timeZone: "Asia/Tokyo"      # タイムゾーン指定
    onTick: ->                  # 時間が来た時に実行する処理
      console.log("cron...")
      list = nurse.getList()
      for site in list
        robot.emit 'healthExamine', site, flags, "bot"
  )

  robot.hear /start job/i, (msg) ->
    msg.send "Start job.."
    cronjob.start()

  robot.hear /stop job/i, (msg) ->
    msg.send "Stop job.."
    cronjob.stop()

  