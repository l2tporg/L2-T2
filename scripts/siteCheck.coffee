# Description
#  hubot-site-health-examineを使ったサイト監視スクリプト
#
# Commands:
#  - []:省略可能, <>:引数
#  [l2-t2] she add <URL:string> <STATUS:int> - 検査するサイトを登録
#  [l2-t2] she list - 登録されたサイトをインデックス付きで表示
#  [l2-t2] she update <INDEX:int> <NEW_STATUS:int> - 登録されたサイトのインデックスと新しいステータスを指定して更新
#  [l2-t2] she remove <INDEX:int> - 登録されたサイトをインデックスを指定して削除
#  [l2-t2] she examine - 監視メソッドを自発的に発火
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
  robot.hear /she examine/i, (msg) ->
    console.log "examing..." #@@
    list = nurse.getList()
    robot.emit 'healthExamine', list, flags, "bot"

  robot.hear /she check/i, (msg) ->
    console.log "examing..." #@@
    list = nurse.getList()
    robot.emit 'healthExamine', list, flags, "20160623hubot-serverc"

  cronjob = new cronJob(
    cronTime: "1 * * * * *"     # 実行時間 s m h d w m
    start:    true              # すぐにcronのjobを実行するか
    timeZone: "Asia/Tokyo"      # タイムゾーン指定
    onTick: ->                  # 時間が来た時に実行する処理
      console.log("cron...")
      list = nurse.getList()
      robot.emit 'healthExamine', list, flags, "bot"
  )

  robot.hear /start job/i, (msg) ->
    msg.send "Start job.."
    cronjob.start()

  robot.hear /stop job/i, (msg) ->
    msg.send "Stop job.."
    cronjob.stop()

  