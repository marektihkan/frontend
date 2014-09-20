_ = require 'lodash'

adminResource     = require '../../resource/admin.coffee'

orderControlDirective = require '../../directive/order-control/order-control.coffee'
questionDirective     = require '../../directive/question/question.coffee'

module.exports = admin = angular.module 'testlab.view.admin', [
  adminResource.name
  orderControlDirective.name
  questionDirective.name
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

  keys: (target) ->
    _(target).keys()
             .filter (key) -> key.charAt(0) isnt '$'
             .value()

admin.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'admin',
    url: '/admin'
    template: require './admin.tpl.html'
    controller: AdminController
    resolve:
      users: [ 'Admin', (Admin) -> Admin.users().$promise ]
]

