through = require 'through2'
_ = require 'lodash'
pkg = require '../../package'

headerTemplate =
  full: """
    /**
     * <%= name %> v<%= version %>
     * <%= homepage %>
     *
     * Copyright Mycolorway Design
     * Released under the MIT license
     * <%= homepage %>/license.html
     *
     * Date: <%= date %>
     */\n\n
  """
  simple: "/* <%= name %> v<%= version %> \
    | (c) Mycolorway Design | MIT License */\n"

module.exports = (type = 'full') ->
  now = new Date()
  year = now.getFullYear()
  month = _.padStart(now.getMonth() + 1, 2, '0')
  date = now.getDate()
  header = _.template(headerTemplate[type])
    name: pkg.name
    version: pkg.version
    homepage: pkg.homepage
    date: "#{year}-#{month}-#{date}"

  through.obj (file, encoding, done) ->
    headerBuffer = new Buffer header
    file.contents = Buffer.concat [headerBuffer, file.contents]
    @push file
    done()
