gutil = require 'gulp-util'
through = require 'through2'
path = require 'path'
sass = require 'node-sass'
_ = require 'lodash'
handleError = require './error'

module.exports = (opts) ->
  through.obj (file, encoding, done) ->
    opts = _.extend
      data: file.contents.toString()
      includePath: [path.dirname(file.path)]
    , opts

    try
      result = sass.renderSync opts
    catch e
      handleError e, @

    file.contents = new Buffer result.css
    file.path = gutil.replaceExtension file.path, '.css'
    @push file
    done()
