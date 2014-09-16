module.exports = (grunt) ->
  require('time-grunt') grunt
  require('load-grunt-tasks') grunt

  # configurable paths
  paths =
    app    : 'app'
    dist   : 'dist'

  grunt.registerTask 'default', [ 'build:dev' ]
  grunt.registerTask 'test', [ 'test:karma' ]
  grunt.registerTask 'test:karma', [ 'browserify:karma', 'karma:single' ]
  grunt.registerTask 'lint', [ 'coffeelint' ]
  grunt.registerTask 'build', [ 'clean', 'browserify:dist', 'copy' ]
  grunt.registerTask 'build:dev', [ 'clean', 'symlink', 'concurrent:dev' ]

  grunt.initConfig
    path: paths

    concurrent:
      options: logConcurrentOutput: true
      dev:
        tasks: [
          'compass:dev'
          'browserify:dev'
          'browserify:karmaDev'
          'karma:dev'
        ]

    clean: dist: [ '<%= path.dist %>' ]

    compass:
      options:
        sassDir: '<%= path.app %>/styles'
        cssDir: '<%= path.app %>/styles'
      dev:
        options: watch: true
      files: 'main.scss'

    # For release we copy the files instead
    copy:
      build:
        expand: true
        cwd: '<%= path.app %>'
        src: [
          'index.html'
          'styles/main.css'
        ]
        dest: '<%= path.dist %>'
      fonts:
        src: '<%= path.app %>/vendor/fontawesome/fonts'
        dest: '<%= path.dist %>/fonts'

    # For development mode we symlink the index.html and stylesheet files
    symlink:
      options: overwrite: true
      dev:
        expand: true
        cwd: '<%= path.app %>'
        src: [
          'index.html'
          'styles/main.css'
          'vendor'
        ]
        dest: '<%= path.dist %>'
      fonts:
        src: '<%= path.app %>/vendor/fontawesome/fonts'
        dest: '<%= path.dist %>/fonts'

    karma:
      single:
        singleRun: true
        configFile: 'karma.conf.coffee'
      dev:
        singleRun: false
        configFile: 'karma.conf.coffee'

    coffeelint:
      options: configFile: 'coffeelint.json'
      files: [ '**/*.coffee', '!node_modules/**/*', '!<%= path.app %>/vendor/**/*' ]

    browserify:
      options:
        watch     : false
        keepAlive : false
        transform : [
          'coffeeify'
          'partialify'
          'debowerify'
        ]

      dev:
        options:
          watch     : true
          keepAlive : true
        files:
          '<%= path.dist %>/scripts/main.js': [ '<%= path.app %>/scripts/main.coffee' ]

      dist:
        files:
          '<%= path.dist %>/scripts/main.js': [ '<%= path.app %>/scripts/main.coffee' ]

      karma:
        files:
          '<%= path.app %>/test/tmp/test-bundle.js': [ '<%= path.app %>/test/**/*.spec.coffee']

      karmaDev:
        options:
          watch     : true
          keepAlive : true
        files:
          '<%= path.app %>/test/tmp/test-bundle.js': [ '<%= path.app %>/test/**/*.spec.coffee']

