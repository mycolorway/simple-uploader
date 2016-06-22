fs = require 'fs'

changelogs = fs.readFileSync('CHANGELOG.md').toString()

lastestVersion = do ->
  result = changelogs.match /## V(\d+\.\d+\.\d+)/

  if result and result.length > 1
    result[1]
  else
    null

latestContent = do ->
  re = new RegExp "## V#{lastestVersion.replace('.', '\\.')}\
    .+\\n\\n((?:\\* .*\\n)+)"
  result = changelogs.match re

  if result and result.length > 1
    result[1]
  else
    null

module.exports =
  lastestVersion: lastestVersion
  latestContent: latestContent
