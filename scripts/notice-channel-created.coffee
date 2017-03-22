# Description:
#   notify create channel on Slack in #new_channels
#
# Notes:
#   required hubot-slack@3.0.0+
#
# Author:
#   sak39  kiris

module.exports = (robot) ->
  robot.adapter.client?.on? 'raw_message', (message) ->
    if message?.type == 'channel_created'
      return if typeof robot?.send isnt 'function'
#      robot.send message
      robot.send {room: "general"}, "New channel <##{message.channel.id}> was created. NJ <@#{message.channel.creator}> !! "
