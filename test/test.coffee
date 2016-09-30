moment = require 'moment'
_ = require 'lodash'

module.exports = (robot) ->
  robot.hear /test/i, (msg) ->
    obj = [
      {url: 'google', status: 200}
      {url: 'yahoo', status: 404}
      {url: 'facebook', status: 200}
    ]
    console.log(_.plunk(obj, url);)
