gulp = require 'gulp'
karma = require 'karma'
fs = require 'fs'
handleError = require './helpers/error'

test = (done) ->
  server = new karma.Server
    configFile: "#{process.cwd()}/karma.coffee"
  , (code) ->
    fs.unlinkSync 'test/coverage-init.js'
    if code != 0
      handleError "karma exit with code: #{code}"
    done()

  server.start()

gulp.task 'test', test
module.exports = test
