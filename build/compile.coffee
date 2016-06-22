gulp = require 'gulp'
_ = require 'lodash'
coffeelint = require './helpers/coffeelint'
browserify = require './helpers/browserify'
sass = require './helpers/sass'
header = require './helpers/header'
rename = require './helpers/rename'
uglify = require './helpers/uglify'
umd = require './helpers/umd'

compileSass = ->
  gulp.src 'src/**/*.scss'
    .pipe sass()
    .pipe header()
    .pipe gulp.dest('dist/')
compileSass.displayName = 'compile-sass'

compileCoffee = ->
  gulp.src 'src/uploader.coffee'
    .pipe coffeelint()
    .pipe browserify()
    .pipe umd()
    .pipe header()
    .pipe gulp.dest('dist/')
compileCoffee.displayName = 'compile-coffee'

compileUglify = ->
  gulp.src ['dist/**/*.js', '!dist/**/*.min.js']
    .pipe uglify()
    .pipe header('simple')
    .pipe rename
      suffix: '.min'
    .pipe gulp.dest('dist/')
compileUglify.displayName = 'compile-uglify'

compileAssets = gulp.parallel compileCoffee, compileSass, (done) ->
  done()

compile = gulp.series compileAssets, compileUglify, (done) ->
  done()

gulp.task 'compile', compile

module.exports = _.extend compile,
  sass: compileSass
  coffee: compileCoffee
  uglify: compileUglify
