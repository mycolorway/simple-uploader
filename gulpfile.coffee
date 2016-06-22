gulp = require 'gulp'
compile = require './build/compile.coffee'
test = require './build/test.coffee'
publish = require './build/publish.coffee'
coffeelint = require './build/helpers/coffeelint.coffee'

lint = ->
  gulp.src 'build/**/*.coffee'
    .pipe coffeelint()

gulp.task 'default', gulp.series lint, compile, test, (done) ->
  gulp.watch 'build/**/*.coffee', lint

  gulp.watch 'src/**/*.coffee', gulp.series compile.coffee, test
  gulp.watch 'src/**/*.scss', compile.sass
  gulp.watch 'test/**/*.coffee', test

  done()
