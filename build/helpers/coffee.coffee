gutil = require 'gulp-util'
through = require 'through2'
coffee = require 'coffee-script'
handleError = require './error'

module.exports = (opts) ->
  through.obj (file, encoding, done) ->
    str = file.contents.toString()

    try
      result = coffee.compile str, opts
    catch e
      handleError e, @

    file.contents = new Buffer result
    file.path = gutil.replaceExtension file.path, '.js'
    @push file
    done()
