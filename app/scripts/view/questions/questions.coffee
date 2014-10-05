userResource     = require '../../resource/user.coffee'
questionResource = require '../../resource/questions.coffee'
envResource      = require '../../resource/env.coffee'

paginationDirective = require '../../directive/pagination/pagination.coffee'

_ = require 'lodash'

module.exports = questions = angular.module 'testlab.view.questions', [
  userResource.name
  envResource.name
  questionResource.name
  paginationDirective.name
  'classy'
  'ui.router'
]

questions.config [ '$stateProvider', ($stateProvider) ->

  # We only resolve the user
  # if it is not finished yet
  userResolve = (User, $q) ->
    deffered = $q.defer()
    User.get (user) ->
      return deffered.reject() if user.finishedAt
      deffered.resolve user
    , deffered.reject
    deffered.promise

  $stateProvider.state 'question',
      url: 'question'
      template: require './questions.tpl.html'
      controller: QuestionsController
      resolve:
        questions : [ 'Question', (Question) -> Question.list().$promise ]
        env       : [ 'Env', (Env) -> Env.get().$promise ]
]

QuestionsController = questions.classy.controller
  inject: [
    '$scope'
    '$state'
    '$window'
    'questions'
    'env'
  ]

  init: ->
    @$scope.questions = @questions
    @$state.go 'question.id', id: _.first(@questions).id

  getQuestionIndex: ->
    id = @$state.params.id
    _.findIndex @questions, { id }

  getLastId: ->
    index = @getQuestionIndex()
    @questions[index - 1]?.id

  getNextId: ->
    index = @getQuestionIndex()
    @questions[index + 1]?.id

  isActive: (id) ->
    @$state.params.id is id

  validatePageChange: ->
    # isQuestionDrity is changed directly from question subview.
    # Yep, so that happens.
    return true unless @$scope.isQuestionDirty
    @$window.confirm 'Your changes will be lost. Are you sure?'


  changePage: (index) ->
    { id } = @questions[index] or {}
    return unless id
    @$state.go 'question.id', { id } if @validatePageChange()
