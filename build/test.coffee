gulp = require 'gulp'
karma = require 'karma'
handleError = require './helpers/error'

test = (done) ->
  server = new karma.Server
    configFile: "#{process.cwd()}/karma.coffee"
  , (code) ->
    if code != 0
      handleError "karma exit with code: #{code}"
    done()

  server.start()

gulp.task 'test', test
module.exports = test
