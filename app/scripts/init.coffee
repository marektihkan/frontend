_            = require 'lodash'
userResource = require './resource/user.coffee'
envResource  = require './resource/env.coffee'

module.exports = init = angular.module 'testlab.init', [
  envResource.name
  userResource.name
  'ui.router'
]

init.config [ '$httpProvider', '$injector', ($httpProvider, $injector) ->
  $state = null
  $httpProvider.interceptors.push [ '$q', '$injector', ($q, $injector) ->
     'responseError': (response) ->
       if response.status is 403
         $state ?= $injector.get '$state'
         $state.go 'login'
       $q.reject response
  ]
]

init.run [ 'User', 'Env', '$state', '$rootScope', '$timeout', '$q', (User, Env, $state, $rootScope, $timeout, $q) ->

  # Initial routing for the user
  userPromise = User.get (user) ->
    path = 'profile'
    path = 'question' if user.isStarted
    path = 'result'   if user.finishedAt
    path = 'admin'    if user.admin
    $state.go path

  envPromise = Env.get (env) ->
    $rootScope.title = env.title

  # When our user starts the test
  # lets make sure we keep track on his time and refresh the page
  # when user timeleft reaches 0
  $q.all([ userPromise.$promise, envPromise.$promise ]).then ([user, env]) ->
    # If the user change happens lets start the state checking
    $rootScope.$watch (-> user), ->
      { startedAt, finishedAt, timeLeft } = user or {}
      $timeout.cancel timerId
      if startedAt and not finishedAt and timeLeft > 0
        timerId = $timeout (-> location.reload()), timeLeft

]
