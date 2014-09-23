module.exports = (config) ->
  config.set
    basePath: './'
    browsers: [
      'PhantomJS'
      # 'Chrome' # Enable this when actually want to debug in chrome
    ]

    frameworks: [ 'mocha', 'chai' ]
    reporters: [ 'progress' ]

    # browserify:
    #   transform: [ 'coffeeify', 'debowerify']
    #   watch: false   # Watches dependencies only (Karma watches the tests)

    files: [
      # Jquery for testing only
      './app/vendor/jquery/dist/jquery.js'

      # Library files needed to be in global scope
      './app/vendor/angular/angular.js'
      './app/vendor/angular-mocks/angular-mocks.js'
      './app/vendor/angular-resource/angular-resource.js'
      './app/vendor/angular-ui-router/release/angular-ui-router.js'
      './app/vendor/angular-classy/angular-classy.js'
      './app/vendor/angular-sanitize/angular-sanitize.js'

      # Init the actual tests
      './test/tmp/test-bundle.js'
    ]

    preprocessors:
      './test/**/*.coffee': [ 'coffee' ]

    coverageReporter:
      type: 'text'
