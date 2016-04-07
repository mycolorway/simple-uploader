gutil = require 'gulp-util'

module.exports = (error, stream) ->
  if stream
    opts = if typeof error == 'string'
      {}
    else
      stack: error.stack
      showStack: !!error.stack

    stream.emit 'error', new gutil.PluginError 'gulp-build', error, opts
  else
    gutil.log gutil.colors.red("gulp-build error: #{error.message || error}")
