# Description
#   コードのサンドボックス環境。test()で呼び出して、process.exit()で抜ける。
#
# Author:
#   @sak39
#
# Thanks:
#   http://yohshiy.blog.fc2.com/blog-entry-314.html


_ = require 'underscore'
__ = require 'lodash'
request = require 'request'


module.exports = (robot) ->
#  robot.hear /test/i, (msg) ->
  test = ->
#    useCommonArray()
#    useHashArray()
#    underscoreTest()
#    lodashTest()
#    extendedArgs(0, 1, 2)
#    existOperator()
    console.log "module: ", module
    console.log "module.exports: ", module.exports
    console.log "exports: ", exports
#    process.exit()
#    switch msg
#      when 1
#        console.log "hoge"
#      else
#        console.log "fuga"

#    msg.send "hi hello" #複数引数を渡すと複数発言
#    msg.send sayHello ("sak") #()は省略可能



  ####### Modules ########
  #可変長引数
  extendedArgs = (args...) ->
    console.log(args)

  #exist operator
  existOperator = ->
    a = null
    b = undefined
    console.log(a?)
    console.log(b?)

  #null,undefined
  NullUndefined = ->
    a = null
    b = undefined
    console.log(!a) #-> true
    console.log(!b) #-> true

  #say Hello!
  sayHello = (name) ->
    console.log "Hello #{name}"

  #Arrayの検証
  useCommonArray = ->
    array = [
      'one'
      'two'
      'three'
    ]
    for value,i in array
      console.log "i=" + i + ",value = " + value #ここvalue[i]でなくてもOK?

  #連想配列
  useHashArray = ->
    user = 'sak'
    passwd = 'saksak'
    array = {
      user: user
      passwd: passwd
    }
    console.log array

  ### underscore ###
  underscoreTest = ->
    obj = [
      {url: 'google', status: 200}
      {url: 'yahoo', status: 404}
      {url: 'facebook', status: 200}
    ]
    ###pluckとmapは似た者同士###
#    new_obj = _.pluck(obj, 'url')
    new_obj = _.map(obj, 'url')
    index = new_obj.indexOf('yahoo')
    console.log(new_obj)

  ### lodash ###
  lodashTest = ->
    obj = [
      {url: 'google', status: 200}
      {url: 'yahoo', status: 404}
      {url: 'facebook', status: 200}
    ]
    new_obj = __.map(obj, 'url')
    index = new_obj.indexOf('yahoo')
    console.log(index)
    console.log(__.findIndex(obj, {url: 'google'}))
    console.log(_.contains(new_obj, 'yahoo'))

  ### get, post ####
  robot.respond /search (.*)/i, (msg) ->
    searchText = msg.match[1]
    data =
      hoge: 'hoge'
      fuga: 'fuga'
    robot.http('http://example.com')
      .get() (err, res, body) ->
        if err
          msg.send "sorry, #{msg.message.user.name}. I cannot understand..."
      .post(data) (err, res, body) ->
        # 同上


  #### request #####
  robot.respond /request (.*)/i, (msg) ->
    ### header定義 ###
    headers = {
      'Content-Type':'application/json'
    }
    ### option定義 ###
    options = {
      url: 'https://hoge.com/api/v2/fuga',
      method: 'POST',
      headers: headers,
      json: true,
      form: {"hoge":"fuga"},
  #    auth: {
  #      user: "username",
  #      password: "password"
  #    }
    }

#  asyncTest = ->
#    async.series([
#        function (callback) {
#        setTimeout(function() {
#            console.log('first');
#          },3000);
#        callback();
#      },
#      function (callback) {
#        setTimeout(function() {
#            console.log('second');
#          },3000);
#        callback();
#      },
#      function (callback) {
#        setTimeout(function() {
#            console.log('third');
#          },3000);
#        callback();
#      }
#    ], function (err) {
#      if (err) {
#          throw err;
#        }
#      setTimeout(function() {
#          console.log('all done');
#          ck({"status": "error",
#                "statusCode": null,
#    "discription": "ERROR: \"" + data.url + "\" Connection fail."}
#              , msg);
#        }, 3000);
#      });
    ### request送信 ###
#    request(options, (error, response, body)) ->
  #test module
#  test()

