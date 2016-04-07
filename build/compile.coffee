gulp = require 'gulp'
fs = require 'fs'
runSequence = require 'run-sequence'
coffeelint = require './helpers/coffeelint'
coffee = require './helpers/coffee'
sass = require './helpers/sass'
header = require './helpers/header'
rename = require './helpers/rename'
uglify = require './helpers/uglify'
changelogs = require './helpers/changelogs'

gulp.task 'compile.version', ->
  newVersion = changelogs.lastestVersion
  unless newVersion
    throw new Error('Publish: Invalid version in CHANGELOG.md')
    return

  pkg = require '../package'
  pkg.version = newVersion
  fs.writeFileSync './package.json', JSON.stringify(pkg, null, 2)

  bowerConfig = require '../bower.json'
  bowerConfig.version = newVersion
  fs.writeFileSync './bower.json', JSON.stringify(bowerConfig, null, 2)

gulp.task 'compile.coffee', ->
  gulp.src 'src/**/*.coffee'
    .pipe coffeelint()
    .pipe coffee()
    .pipe header()
    .pipe gulp.dest('dist/')

gulp.task 'compile.sass', ->
  gulp.src 'src/**/*.scss'
    .pipe sass()
    .pipe header()
    .pipe gulp.dest('dist/')

gulp.task 'compile.uglify', ->
  gulp.src ['dist/**/*.js', '!dist/**/*.min.js']
    .pipe uglify()
    .pipe header('simple')
    .pipe rename
      suffix: '.min'
    .pipe gulp.dest('dist/')

gulp.task 'compile', (done) ->
  runSequence(
    'compile.version',
    'compile.coffee',
    'compile.uglify',
  
    'compile.sass',
  
    done
  )
