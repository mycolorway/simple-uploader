module.exports = (config) ->
  config.set

    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: ''


    # frameworks to use
    # available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['coffee-coverage', 'browserify', 'mocha', 'chai', 'sinon']


    # list of files / patterns to load in the browser
    files: [
      'node_modules/jquery/dist/jquery.js'
      'node_modules/simple-module/dist/simple-module.js'
      'test/coverage-init.js'
      'src/simple-uploader.coffee',
      'test/**/*.coffee'
    ]


    # list of files to exclude
    exclude: [
    ]


    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors:
      'src/simple-uploader.coffee': ['browserify']
      'test/**/*.coffee': ['browserify']


    browserify:
      transform: [['browserify-coffee-coverage', {noInit: true, instrumentor: 'istanbul'}]]
      extensions: ['.js', '.coffee']


    coffeeCoverage:
      framework:
        initAllSources: true
        sourcesBasePath: 'src'
        dest: 'test/coverage-init.js'
        instrumentor: 'istanbul'


    coverageReporter:
      dir: 'coverage'
      subdir: '.'
      reporters: [
        { type: 'lcovonly' }
        { type: 'text-summary' }
      ]


    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['coverage', 'mocha']


    # web server port
    port: 9876


    # enable / disable colors in the output (reporters and logs)
    colors: true


    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO


    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: false


    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['PhantomJS']


    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: true

    # Concurrency level
    # how many browser should be started simultaneous
    concurrency: Infinity
