adminResource     = require '../../resource/admin.coffee'
questionDirective = require '../../directive/question/question.coffee'

resultCalc = require '../../lib/result-calc.coffee'
timeTaken  = require '../../lib/time-taken.coffee'

module.exports = admin = angular.module 'testlab.view.admin', [
  adminResource.name
  'classy'
  'ui.router'
]

AdminController = admin.classy.controller
  inject: [
    '$scope'
    'users'
  ]

  init: ->
    @$scope.users = @users

  calculateResult: (questions) ->
    res = resultCalc(questions).toFixed 2
    res * 100

  getTimeTaken: ({ startedAt, finishedAt} = {}) ->
    timeTaken startedAt, finishedAt

admin.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'admin',
    url: '/admin'
    template: require './admin.tpl.html'
    controller: AdminController
    resolve:
      users: [ 'Admin', (Admin) -> Admin.users().$promise ]
]

