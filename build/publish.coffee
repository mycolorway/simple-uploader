gulp = require 'gulp'
gutil = require 'gulp-util'
ghPages = require 'gulp-gh-pages'
runSequence = require 'run-sequence'
fs = require 'fs'
request = require 'request'
changelogs = require './helpers/changelogs'
removeDir = require './helpers/remove-dir'
handleError = require './helpers/error'

gulp.task 'publish.docs', ['docs.jade'], ->
  gulp.src '_docs/**/*'
    .pipe ghPages().on 'end', -> removeDir '.publish'

gulp.task 'publish.createRelease', ->
  try
    token = require '../.token.json'
  catch e
    throw new Error 'Publish: Need github access token for creating release.'
    return

  createRelease token.github

gulp.task 'publish', ->
  runSequence 'compile', 'test', 'docs', 'publish.docs', 'publish.createRelease'


createRelease = (token) ->
  pkg = require '../package'
  content = changelogs.latestContent
  unless content
    throw new Error('Publish: Invalid release content in CHANGELOG.md')
    return

  request
    uri: "https://api.github.com/repos/#{pkg.githubOwner}/#{pkg.name}/releases"
    method: 'POST'
    json: true
    body:
      tag_name: "v#{pkg.version}",
      name: "v#{pkg.version}",
      body: content,
      draft: false,
      prerelease: false
    headers:
      Authorization: "token #{token}",
      'User-Agent': 'Mycolorway Release'
  , (error, response, body) ->
    if error
      handleError error
    else if response.statusCode.toString().search(/2\d\d/) > -1
      message = "#{pkg.name} v#{pkg.version} released on github!"
      gutil.log gutil.colors.green message
    else
      message = "#{response.statusCode} #{JSON.stringify response.body}"
      handleError gutil.colors.red message
