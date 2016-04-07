through = require 'through2'
gutil = require 'gulp-util'
coffeeCoverage = require 'coffee-coverage'
handleError = require './error'

coverageVar = '__coverage__'
instrumentor = new coffeeCoverage.CoverageInstrumentor
  instrumentor: 'istanbul'
  basePath: process.cwd()
  exclude: [
    '/test'
    '/node_modules'
    '/.git'
    'gulpfile.coffee'
    '/build'
    '/docs'
    '/src/i18n'
  ]
  coverageVar: coverageVar
  initAll: true

module.exports = (opts = {}) ->
  through.obj (file, encoding, done) ->
    str = file.contents.toString()

    try
      result = instrumentor.instrumentCoffee file.path, str, opts
    catch e
      handleError e, @

    file.contents = new Buffer(result.init + result.js)
    file.path = gutil.replaceExtension file.path, '.js'
    @push file
    done()

module.exports.coverageVar = coverageVar
