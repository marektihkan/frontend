questionTemplates = require '../../question-templates/index.coffee'

module.exports = question = angular.module 'testlab.directive.question', [
  questionTemplates.name
]

question.directive 'question', ->
  template: require './question-wrapper.tpl.html'
  scope:
    question : '='
    answer   : '='
    disabled : '='
  compile: (el, attrs) ->
    attrs.disabled ?= false



