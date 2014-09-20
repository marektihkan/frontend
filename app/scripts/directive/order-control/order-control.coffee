_ = require 'lodash'

module.exports = orderControl = angular.module 'testlab.directive.ordercontrol', [ 'classy' ]

getOpposite = (key) ->
  return key.substr 1 if key.charAt(0) is '!'
  "!#{key}"


OrderControlController = orderControl.classy.controller
  inject: [
    '$scope'
  ]

  orderFilterFn: (val) ->
    not _.find @$scope.orderExpression, (expression) =>
      val is @removeExcess expression

  addToOrder: (sortKey) ->
    return unless sortKey
    @$scope.orderExpression.push sortKey

  removeFromOrder: (key) ->
    index = @$scope.orderExpression.indexOf key
    @$scope.orderExpression.splice index, 1

  removeExcess: (key) ->
    return key unless @isAsc key
    key.substr 1

  toggleAsc: (key) ->
    index = @$scope.orderExpression.indexOf key
    @$scope.orderExpression[index] = getOpposite key

  isAsc: (key) ->
    key?.charAt(0) is '!'

orderControl.directive 'orderControl', ->
  template: require './order-control.tpl.html'
  controller: OrderControlController
  scope:
    orderExpression: '=orderControl'
    keys: '&'
