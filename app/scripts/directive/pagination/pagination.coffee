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
    new Array Math.min @$scope.totalItems, nr

  getCalculatedPageNr: (nr) ->
    currentPage = @$scope.currentPage()
    return nr if @$scope.maxItems is @$scope.totalItems
    median = Math.floor @$scope.maxItems / 2
    if currentPage + median > @$scope.totalItems
      @$scope.totalItems + nr - @$scope.maxItems
    else
      Math.max(currentPage - median, 0) + nr

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
