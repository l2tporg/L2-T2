Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/example.coffee')

describe 'Examine', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()



  it 'responds to ping', ->
    @room.user.say('alice', '@hubot ping').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot ping']
        ['hubot', '@alice PONG']
      ]
#
#  it 'responds to hello', ->
#    @room.user.say('Shell', '@l2-t2 ping').then =>
#      expect(@room.messages).to.eql [
#        ['Shell', '@l2-t2 ping']
#        ['l2-t2', 'PONG']
#
#      ]
#
#  it 'hears orly', ->
#    @room.user.say('bob', 'just wanted to say orly').then =>
#      expect(@room.messages).to.eql [
#        ['bob', 'just wanted to say orly']
#        ['hubot', 'yarly']
#      ]
