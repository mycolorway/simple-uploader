gulp = require 'gulp'
coffeelint = require './helpers/coffeelint'
coffee = require './helpers/coffee'
coffeeCoverage = require './helpers/coffee-coverage'
mochaPhantomjs = require './helpers/mocha-phantomjs'
rename = require './helpers/rename'
runSequence = require 'run-sequence'

gulp.task 'test.compileTest', ->
  gulp.src 'test/**/*.coffee'
    .pipe coffeelint()
    .pipe coffee()
    .pipe rename
      suffix: '-test'
    .pipe gulp.dest('test/runner')

gulp.task 'test.compileSrc', ->
  gulp.src 'src/**/*.coffee'
    .pipe coffeelint()
    .pipe coffeeCoverage()
    .pipe gulp.dest('test/runner')

gulp.task 'test', (done) ->
  runSequence ['test.compileTest', 'test.compileSrc'], ->
    mochaPhantomjs 'test/runner/index.html', done
