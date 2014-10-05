module.exports = adminRowLarge = angular.module 'test-lab.directive.admin-row-large', [
  'classy'
]

AdminRowController = adminRowLarge.classy.controller
  inject: [
    '$scope'
  ]

  canShowAnswer: (isShown, isLast) ->
    return isShown if isShown
    isLast and not isShown?

  toggleHidden: (user) ->
    user.$update()

adminRowLarge.directive 'adminRowLarge', ->
  template   : require './admin-row-large.tpl.html'
  controller : AdminRowController
  scope      :
    user: '=adminRowLarge'
