cronJob = require('cron').CronJob

module.exports = (robot) ->
  sayHello = ->
      robot.send {room: "#sak39_sandbox"}, "おはようございます！"

  cronjob = new cronJob(
    cronTime: "0 1 0 * * *"     # 実行時間 s m h d w m
    start:    true              # すぐにcronのjobを実行するか
    timeZone: "Asia/Tokyo"      # タイムゾーン指定
    onTick: ->                  # 時間が来た時に実行する処理
      sayHello()
  )

  robot.respond /hello/i, (msg) ->
    msg.send 'World!'

    ### 毎分hello ###
#  IntervalHello = new cronJob(
#    cronTime: '10 * * * * *'
#    start: true
#    timeZone: "Asia/Tokyo"
#    onTick: ->
#      robot.send {room: "sak39_sandbox"}, "Can I help you?"
#  )
