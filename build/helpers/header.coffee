fs = require 'fs'
through = require 'through2'
_ = require 'lodash'
pkg = require '../../package'

module.exports = (type = 'full') ->
  now = new Date()
  year = now.getFullYear()
  month = _.padStart(now.getMonth() + 1, 2, '0')
  date = now.getDate()
  tpl = fs.readFileSync("build/templates/#{type}-header.txt").toString()
  header = _.template(tpl)
    name: pkg.name
    version: pkg.version
    homepage: pkg.homepage
    date: "#{year}-#{month}-#{date}"

  through.obj (file, encoding, done) ->
    headerBuffer = new Buffer header
    file.contents = Buffer.concat [headerBuffer, file.contents]
    @push file
    done()
