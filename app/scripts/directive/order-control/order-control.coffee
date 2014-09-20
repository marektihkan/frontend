_ = require 'lodash'

module.exports = orderControl = angular.module 'testlab.directive.ordercontrol', [ 'classy' ]

OrderControlController = orderControl.classy.controller
  inject: [
    '$scope'
  ]

  orderFilterFn: (val) ->
    console.log val
    not _.contains @$scope.orderExpression, val

  addToOrder: (sortKey) ->
    return unless sortKey
    @$scope.orderExpression.push sortKey

  removeFromOrder: (key) ->
    index = @$scope.orderExpression.indexOf key
    @$scope.orderExpression.splice index, 1

orderControl.directive 'orderControl', ->
  template: require './order-control.tpl.html'
  controller: OrderControlController
  scope:
    orderExpression: '=orderControl'
    keys: '&'
