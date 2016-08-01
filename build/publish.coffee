gulp = require 'gulp'
gutil = require 'gulp-util'
fs = require 'fs'
request = require 'request'
changelogs = require './helpers/changelogs'
handleError = require './helpers/error'
compile = require './compile'
test = require './test'
_ = require 'lodash'

createRelease = (done) ->
  try
    token = _.trim fs.readFileSync('.token').toString()
  catch e
    throw new Error 'Publish: Need github access token for creating release.'
    return

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
    done()
createRelease.displayName = 'create-release'

publish = gulp.series [
  compile,
  test,
  createRelease
]..., (done) ->
  done()

gulp.task 'publish', publish

module.exports = publish
