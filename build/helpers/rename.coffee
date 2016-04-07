_ = require 'lodash'
through = require 'through2'
path = require 'path'

module.exports = (opts) ->
  opts = _.extend
    prefix: ''
    suffix: ''
    dirname: null
    basename: null
    extname: null
  , opts

  through.obj (file, encoding, done) ->
    dirname = path.dirname file.relative
    extname = path.extname file.relative
    basename = path.basename file.relative, extname
    newDirName = if _.isNull(opts.dirname) then dirname else opts.dirname
    newExtName = if _.isNull(opts.extname) then extname else opts.extname
    newBaseName = if _.isNull(opts.basename) then basename else opts.basename

    filename = "#{opts.prefix}#{newBaseName}#{opts.suffix}#{newExtName}"
    file.path = path.join file.base, newDirName, filename
    @push file
    done()
