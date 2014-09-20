_      = require 'lodash'
moment = require 'moment'

resultCalc = require '../../lib/result-calc.coffee'

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

  calculateResult: (questions) ->
    res = resultCalc(questions).toFixed 2
    res * 100

  calculateTimeTaken: ({ startedAt, finishedAt }) ->
    return if not startedAt or not finishedAt
    started  = moment startedAt
    finished = moment finishedAt
    duration = moment.duration finished.diff started
    duration.minutes()

result.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'result',
    url: '/result',
    template: require './result.tpl.html'
    controller: ResultController
    resolve:
      result : [ 'Result', (Result) -> Result.get().$promise ]
      user   : [ 'User', (User) -> User.get().$promise ]
]
