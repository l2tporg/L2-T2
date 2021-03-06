# Description
#   検査対象のサイトのurl、statusCodeのCRUD処理
#
# Author:
#   @sak39
#
# Thanks:
#   http://sota1235.hatenablog.com/entry/2015/06/15/001400

_ = require 'lodash'

class Urls
  constructor: (robot) ->
    @robot = robot
    @key = 'sites'

  ###### Modules #######
  # @getData
  getData: ->
    data = robot.brain.get(key) ? []
#    data = robot.brain.get(key) or {} #ハッシュで管理する場合はこちら
    return data

  ### Remove ###
  removeSite: (index) ->
    data = @getData()
    ### エラーチェック(範囲外判定) ###
    if index > (_.size(data) - 1)
      return false
    ###上手くいかない###
#    if index > (data.length - 1)
#      console.log data.length
#      return false
    ### 最後の出力に使う###
    tmp = {"url": data[index].url, "status": data[index].status} #避難
    ### indexから1つ削除 ###
    data.splice(index, 1)
    return tmp

  ### Update ###
  updateSite: (index, newStatus) ->
    data = @getData()
    if index > (_.size(data) - 1)
      return false
    data[index].status = newStatus
    return true

  #Search Index of HashArray
  searchIndex: (obj, key) ->
    new_obj = _.map(obj, 'url')
    index = new_obj.indexOf(key)
    if index > -1
      return index
    else
      return false

  #Check elements conflisction
  checkConfliction: (obj, key) ->
    #存在したらfalseを返す
    if _.findIndex(obj, {url: key}) > -1
      return false
    else
      return true

module.exports = Urls
