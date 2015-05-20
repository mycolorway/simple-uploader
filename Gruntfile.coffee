module.exports = (grunt) ->

  grunt.initConfig

    pkg: grunt.file.readJSON 'package.json'

    coffee:
      src:
        options:
          bare: true
        files: 'lib/uploader.js': 'src/uploader.coffee'
      spec:
        files:
          'spec/uploader-spec.js': 'spec/uploader-spec.coffee'

    umd:
      all:
        src: 'lib/uploader.js'
        template: 'umd.hbs'
        amdModuleId: 'simple-uploader'
        objectToExport: 'uploader'
        globalAlias: 'uploader'
        deps:
          'default': ['$', 'SimpleModule']
          amd: ['jquery', 'simple-module']
          cjs: ['jquery', 'simple-module']
          global:
            items: ['jQuery', 'SimpleModule']
            prefix: ''

    watch:
      src:
        files: ['src/**/*.coffee']
        tasks: ['coffee', 'umd']
      spec:
        files: ['spec/**/*.coffee']
        tasks: ['coffee:spec']
      jasmine:
        files: ['lib/**/*.js', 'specs/**/*.js']
        tasks: 'jasmine:test:build'

    jasmine:
      test:
        src: ['lib/**/*.js']
        options:
          outfile: 'spec/index.html'
          specs: 'spec/uploader-spec.js'
          vendor: [
            'vendor/bower/jquery/dist/jquery.min.js'
            'vendor/bower/simple-module/lib/module.js'
            'vendor/bower/jasmine-ajax/lib/mock-ajax.js'
          ]

    express:
      server:
        options:
          server: 'server.js'
          bases: __dirname

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-umd'

  grunt.registerTask 'default', ['coffee', 'umd', 'jasmine:test:build', 'express', 'watch']
