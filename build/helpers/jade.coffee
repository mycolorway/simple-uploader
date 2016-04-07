through = require 'through2'
_ = require 'lodash'
gutil = require 'gulp-util'
jade = require 'jade'
handleError = require './error'

module.exports = (opts) ->
  through.obj (file, encoding, done) ->
    opts = _.extend {filename: file.path}, opts
    file.path = gutil.replaceExtension file.path, '.html'
    try
      jade = require 'jade'
      compile = jade.compile file.contents.toString(), opts
      result = compile _.extend {}, opts.locals, file.data
      file.contents = new Buffer result
    catch e
      handleError e, @
    @push file
    done()
