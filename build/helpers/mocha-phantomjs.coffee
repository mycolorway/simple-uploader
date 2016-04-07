fs = require 'fs'
path = require 'path'
istanbul = require 'istanbul'
childProcess = require 'child_process'
phantomjs = require 'phantomjs-prebuilt'
_ = require 'lodash'
handleError = require './error'
removeDir = require './remove-dir'
rootPath = process.cwd()

module.exports = (testFile, callback) ->
  removeDir 'coverage'

  args = [
    path.join(rootPath, 'node_modules/mocha-phantomjs-core/\
      mocha-phantomjs-core.js'),
    path.join(rootPath, testFile),
    'spec',
    JSON.stringify
      hooks: path.join(rootPath, 'build/helpers/mocha-phantomjs-hooks.js')
  ]

  process = childProcess.spawn phantomjs.path, args

  process.stdout.on 'data', (data) ->
    console.log data.toString()

  process.stderr.on 'data', (data) ->
    console.log data.toString()

  process.on 'error', (error) ->
    handleError error
    callback() if _.isFunction callback

  process.on 'close', (code) ->
    if code == 0
      coverage = JSON.parse fs.readFileSync 'coverage/coverage.json'
      reporter = new istanbul.Reporter()
      collector = new istanbul.Collector()

      reporter.addAll ['lcov', 'text', 'text-summary']
      collector.add(coverage || {})

      reporter.write collector, false, ->
        callback() if _.isFunction callback
    else
      handleError "phantomjs exit with code: #{code}"
      callback() if _.isFunction callback
