through = require 'through2'
uglify = require 'uglify-js'
_ = require 'lodash'
handleError = require './error'

module.exports = (opts) ->
  through.obj (file, encoding, done) ->
    opts = _.extend {fromString: true}, opts

    try
      result = uglify.minify file.contents.toString(), opts
    catch e
      handleError e, @

    file.contents = new Buffer result.code
    @push file
    done()
