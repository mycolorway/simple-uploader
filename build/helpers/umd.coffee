fs = require 'fs'
through = require 'through2'
_ = require 'lodash'
pkg = require '../../package'

module.exports = (opts) ->
  umdConfig = _.cloneDeep pkg.umd
  opts = _.extend umdConfig, opts

  opts.dependencies.cjs = opts.dependencies.cjs.map (name) ->
    "require('#{name}')"
  .join ','

  opts.dependencies.global = opts.dependencies.global.map (name) ->
    "root.#{name}"
  .join ','

  opts.dependencies.params = opts.dependencies.params.join ','

  tpl = _.template fs.readFileSync('build/templates/umd.js').toString()

  through.obj (file, encoding, done) ->
    opts.contents = file.contents.toString()
    opts.filename = file.stem
    file.contents = new Buffer tpl opts
    @push file
    done()
