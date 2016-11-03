Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/Examine.coffee')

describe 'Examine', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()



  it 'responds to hello', ->
    @room.user.say('l2-t2', '@l2-t2 hello').then =>
      expect(@room.messages).to.eql [
        ['l2-t2', '@l2-t2 hello']
        ['l2-t2', 'hello!']
      ]

  it 'responds to hello', ->
    @room.user.say('Shell', '@l2-t2 ping').then =>
      expect(@room.messages).to.eql [
        ['Shell', '@l2-t2 ping']
        ['l2-t2', 'PONG']

      ]

  it 'hears orly', ->
    @room.user.say('bob', 'just wanted to say orly').then =>
      expect(@room.messages).to.eql [
        ['bob', 'just wanted to say orly']
        ['hubot', 'yarly']
      ]
