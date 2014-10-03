_                 = require 'lodash'
questionTemplates = require '../../question-templates/index.coffee'

module.exports = question = angular.module 'testlab.directive.question', [
  questionTemplates.name
  'classy'
  'ngSanitize'
]

QuestionDirectiveController = question.classy.controller
  inject: [
    '$scope'
    '$sce'
  ]

  trustAsHtml: (data) ->
    @$sce.trustAsHtml _.unescape data

question.directive 'question', ->
  template: require './questionWrapper.tpl.html'
  controller : QuestionDirectiveController
  scope:
    question : '='
    answer   : '='
    disabled : '='
  compile: (el, attrs) ->
    attrs.disabled ?= false



