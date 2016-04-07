gulp = require 'gulp'
runSequence = require 'run-sequence'
path = require 'path'
coffeelint = require './helpers/coffeelint'
coffee = require './helpers/coffee'
sass = require './helpers/sass'
removeDir = require './helpers/remove-dir'
data = require './helpers/data'
jade = require './helpers/jade'
rename = require './helpers/rename'

gulp.task 'docs.clean', ->
  removeDir '_docs'

gulp.task 'docs.jade', ->
  gulp.src(['docs/**/*.jade', '!docs/layouts/**/*.jade'])
    .pipe data (file) ->
      pkg: require '../package'
      navItems: require '../docs/data/nav.json'
      filename: path.basename(file.path, '.jade')
    .pipe jade()
    .pipe rename
      dirname: ''
      extname: '.html'
    .pipe gulp.dest '_docs'

gulp.task 'docs.coffee', ->
  gulp.src 'docs/**/*.coffee'
    .pipe coffeelint()
    .pipe coffee()
    .pipe gulp.dest('_docs/')

gulp.task 'docs.sass', ->
  gulp.src 'docs/**/*.scss'
    .pipe sass()
    .pipe gulp.dest('_docs/')

gulp.task 'docs', (done) ->
  runSequence 'docs.clean', [
    'docs.jade',
    'docs.coffee',
    'docs.sass',
  ], done
