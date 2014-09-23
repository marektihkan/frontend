module.exports = pagination = angular.module 'testlab.directive.pagination', [ 'classy' ]

PaginationController = pagination.classy.controller
  inject: [
    '$scope'
  ]

  hasNext: ->
    @$scope.currentPage() isnt @$scope.totalItems - 1

  hasPrev: ->
    @$scope.currentPage() isnt 0

  range: (nr) ->
    new Array nr

  getCalculatedPageNr: (nr) ->
    return nr if @$scope.maxItems is @$scope.totalItems - 1
    median = Math.floor @$scope.maxItems / 2
    offset = Math.max @$scope.currentPage() - median, 0
    if @$scope.currentPage() + median > @$scope.totalItems
      @$scope.maxItems - median + nr
    else
      offset + nr

  changePage: (nr) ->
    @$scope.change()? nr

pagination.directive 'pagination', ->
  template: require './pagination.tpl.html'
  controller: PaginationController
  scope:
    totalItems  : '='
    maxItems    : '='
    currentPage : '&'
    change      : '&'
