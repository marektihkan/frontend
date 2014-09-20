adminResource     = require '../../resource/admin.coffee'
questionDirective = require '../../directive/question/question.coffee'

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

  orderExpression: null

  init: ->
    @$scope.users = @users
    @$scope.orderExpression = []

admin.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'admin',
    url: '/admin'
    template: require './admin.tpl.html'
    controller: AdminController
    resolve:
      users: [ 'Admin', (Admin) -> Admin.users().$promise ]
]

