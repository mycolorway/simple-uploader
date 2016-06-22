gulp = require 'gulp'
karma = require 'karma'

test = (done) ->
  server = new karma.Server
    configFile: "#{process.cwd()}/karma.coffee"
  , done
  server.start()

gulp.task 'test', test
module.exports = test
