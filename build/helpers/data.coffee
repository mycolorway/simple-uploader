through = require 'through2'
_ = require 'lodash'

module.exports = (data) ->
  through.obj (file, encoding, done) ->
    file.data = if _.isFunction(data) then data(file) else data
    @push file
    done()
