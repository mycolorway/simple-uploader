gutil = require 'gulp-util'
_ = require 'lodash'
through = require 'through2'
coffee = require 'coffee-script'
browserify = require 'browserify'
handleError = require './error'

module.exports = (opts) ->
  b = browserify _.extend
    transform: [coffeeify]
    bundleExternal: false
  , opts

  through.obj (file, encoding, done) ->

    try
      b.add file.path
      b.bundle (error, buffer) =>
        handleError(error, @) if error
        file.contents = buffer
        file.path = gutil.replaceExtension file.path, '.js'
        @push file
        done()
    catch e
      handleError e, @
      done()

coffeeify = (filename, opts = {}) ->
  return through() unless /\.coffee$/.test(filename)

  opts = _.extend
    inline: true
    bare: true
    header: false
  , opts

  chunks = []
  through (chunk, encoding, done) ->
    chunks.push chunk
    done()
  , (done) ->
    str = Buffer.concat(chunks).toString()

    try
      result = coffee.compile str, opts
    catch e
      handleError e, @

    @push result
    done()
