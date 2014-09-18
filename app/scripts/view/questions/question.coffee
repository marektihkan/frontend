templates = require './templates/index.coffee'
question  = require '../../resource/questions.coffee'
answer    = require '../../resource/answer.coffee'

_ = require 'lodash'

module.exports = question = angular.module 'testlab.view.question', [
  question.name
  answer.name
  templates.name
  'classy'
  'ui.router'
  'ngSanitize'
]

question.config [ '$stateProvider', ($stateProvider) ->
  # Resolve the questions only if the ID is in questions list
  # if they do not then do not resolve the route
  questionResolve = (Question, $q, $stateParams) ->
    deffered = $q.defer()
    id       = $stateParams.id
    return deffered.reject() unless id
    successCb = (questions) ->
      question = _.find questions, { id }
      return deffered.resolve question if question
      deffered.reject()
    Question.list successCb, deffered.reject
    deffered.promise

  $stateProvider.state 'question.id',
      url: '/:id',
      template: require './question.tpl.html'
      controller: QuestionController
      resolve:
        question: [ 'Question', '$q', '$stateParams', questionResolve ]
        questions: [ 'Question', (Question) -> Question.list() ]
]

QuestionController = question.classy.controller
  inject: [
    '$scope'
    '$state'
    '$sce'
    'question'
    'questions'
    'Answer'
  ]

  init: ->
    @$scope.question = @question
    @$scope.answer   = @Answer.get id: @$state.params.id

  goToNextQuestion: (id) ->
    index  = _.findIndex @questions, { id }
    nextId = @questions[index + 1]?.id
    return unless nextId
    @$state.go 'question.id', id: nextId

  submitAnswer: (question, answer) ->
    id = question.id
    answer.$save { id }, _.partial @goToNextQuestion, id

  allowHtml: (data) ->
    @$sce.trustAsHtml data
