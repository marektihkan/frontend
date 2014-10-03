_      = require 'lodash'

resultCalc = require '../../lib/result-calc.coffee'
timeTaken  = require '../../lib/time-taken.coffee'

resultResource = require '../../resource/result.coffee'
userResource   = require '../../resource/user.coffee'

questionDirective = require '../../directive/question/question.coffee'

module.exports = result = angular.module 'testlab.view.result', [
  questionDirective.name
  resultResource.name
  userResource.name
  'ui.router'
  'classy'
]

ResultController = result.classy.controller
  inject: [
    '$scope'
    'result'
    'env'
  ]

  init: ->
    @$scope.result = @result

  getNumberAnswered: (questions) ->
    _.reduce questions, (nr, question) ->
      nr++ if question.answer
      nr
    , 0

  isValid: (question) ->
    question.answer?.valid

  showScore: ->
    @env.showScore isnt false

  calculateResult: resultCalc

  calculateTimeTaken: ({startedAt, finishedAt} = {}) ->
    timeTaken startedAt, finishedAt

result.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'result',
    url: '/result',
    template: require './result.tpl.html'
    controller: ResultController
    resolve:
      result : [ 'Result', (Result) -> Result.get().$promise ]
      user   : [ 'User', (User) -> User.get().$promise ]
      env    : [ 'Env', (Env) -> Env.get().$promise ]
]
