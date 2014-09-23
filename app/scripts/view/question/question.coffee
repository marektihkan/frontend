questionDirective = require '../../directive/question/question.coffee'
questionResource  = require '../../resource/questions.coffee'
answerResource    = require '../../resource/answer.coffee'

_ = require 'lodash'

module.exports = question = angular.module 'testlab.view.question', [
  questionDirective.name
  questionResource.name
  answerResource.name
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
    successCb = (questions) ->
      question = _.find questions, { id } if id
      # If the question was not found use the first question availble
      deffered.resolve question or _.first questions
    Question.list successCb, deffered.reject
    deffered.promise

  $stateProvider.state 'question.id',
      url: '/:id',
      template: require './question.tpl.html'
      controller: QuestionController
      resolve:
        user      : ['User', (User) -> User.get().$promise ]
        question  : [ 'Question', '$q', '$stateParams', questionResolve ]
        questions : [ 'Question', (Question) -> Question.list().$promise ]
]

QuestionController = question.classy.controller
  inject: [
    '$scope'
    '$state'
    '$sce'
    'question'
    'questions'
    'user'
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

  saveAnswer: ({ id }, answer, cb) ->
    answer.$save { id }, cb

  submitAnswer: (question, answer) ->
    @saveAnswer question, answer, _.partial @goToNextQuestion, question.id

  finish: (question, answer) ->
    @saveAnswer question, answer, =>
      @user.$finish =>
        @$state.go 'result'

  currentPage: ->
    @$state.params.id

  allowHtml: (data) ->
    @$sce.trustAsHtml data
