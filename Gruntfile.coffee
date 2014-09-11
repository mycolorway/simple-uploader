module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffee:
      module:
        files: 'lib/uploader.js': 'src/uploader.coffee'
    watch:
      scripts:
        files: ['src/*.coffee']
        tasks: ['coffee']

    express:
      server:
        options:
          server: 'server.js'
          bases: __dirname

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express'

  grunt.registerTask 'default', ['coffee', 'express', 'watch']


