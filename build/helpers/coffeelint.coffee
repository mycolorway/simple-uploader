through = require 'through2'
coffeelint = require 'coffeelint'
Reporter = require 'coffeelint/lib/reporters/default'
configFinder = require 'coffeelint/lib/configfinder'
handleError = require './error'

module.exports = ->
  through.obj (file, encoding, done) ->
    opts = configFinder.getConfig()
    errorReport = coffeelint.getErrorReport()
    errorReport.lint file.relative, file.contents.toString(), opts

    summary = errorReport.getSummary()
    if summary.errorCount > 0 || summary.warningCount > 0
      reporter = new Reporter errorReport
      reporter.publish()
      handleError 'coffeelint failed with errors or warnings', @

    @push file
    done()
