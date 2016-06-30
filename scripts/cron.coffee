# Description
#   node-cronで定期実行
#
# Author:
#   @sak39
#
# Thanks:
#   http://qiita.com/hotakasaito/items/03386fe1a68e403f5cb8

cronJob = require('cron').CronJob

module.exports = (robot) ->
#  sayHello = ->
#      robot.send {room: "#bot"}, "おはようございます！"
  cronjob = new cronJob(
    cronTime: "0 0 1 * * * *"     # 実行時間 s m h d w m
    start:    true              # すぐにcronのjobを実行するか
    timeZone: "Asia/Tokyo"      # タイムゾーン指定
    onTick: ->                  # 時間が来た時に実行する処理
      # checkd url #
      robot.emit 'healthcheck:url', {url: 'https://www.google.com', status: 200}
      robot.emit 'healthcheck:url', {url: 'http://takamachi.com/hogehoge', status: 200}
      robot.emit 'healthcheck:url', {url: 'http://sasukene.info', status: 500}
    
#      robot.send {room: "#bot"}, "おはようございます！"
  )

  robot.hear /start job/i, (msg) ->
    msg.send "Start job.."
    cronjob.start()

  robot.hear /stop job/i, (msg) ->
    msg.send "Stop job.."
    cronjob.stop()
#
#  robot.hear /hello/i, (msg) ->
#    msg.send 'World!'

### 毎分hello ###
#  IntervalHello = new cronJob(
#    cronTime: '10 * * * * *'
#    start: true
#    timeZone: "Asia/Tokyo"
#    onTick: ->
#      robot.send {room: "sak39_sandbox"}, "Can I help you?"
#  )
