_ = require 'lodash'

adminResource = require '../../resource/admin.coffee'

orderControlDirective  = require '../../directive/order-control/order-control.coffee'
questionDirective      = require '../../directive/question/question.coffee'
adminRowLargeDirective = require '../../directive/admin-row-large/admin-row-large.coffee'

module.exports = admin = angular.module 'testlab.view.admin', [
  adminResource.name
  orderControlDirective.name
  questionDirective.name
  adminRowLargeDirective.name
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
    @$scope.orderExpression = [
      '!calculatedResult'
    ]

  getSortKeys: ->
    [
      'name'
      'timeTaken'
      'calculatedResult'
    ]

  hasId: (user) ->
    user.id?

  isHidden: (user) ->
    user.meta?.hidden is true

  isShown: (user) ->
    not @isHidden user

admin.config [ '$stateProvider', ($stateProvider) ->
  $stateProvider.state 'admin',
    url: '/admin'
    template: require './admin.tpl.html'
    controller: AdminController
    resolve:
      users: [ 'Admin', (Admin) -> Admin.users().$promise ]
]

