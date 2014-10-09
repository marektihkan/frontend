module.exports = adminRowLarge = angular.module 'test-lab.directive.admin-row-large', [
  'classy'
]

AdminRowController = adminRowLarge.classy.controller
  inject: [
    '$scope'
    '$window'
  ]

  canShowAnswer: (isShown, isLast) ->
    return isShown if isShown
    isLast and not isShown?

  toggleHidden: (user) ->
    user.$update()

  remove: (user) ->
    if @$window.confirm 'Are you sure? This cannot be undone.'
      user.$remove()

  hide: (user) ->
    user.meta ?= {}
    user.meta.hidden = not user.meta.hidden
    user.$update()

adminRowLarge.directive 'adminRowLarge', ->
  template   : require './admin-row-large.tpl.html'
  controller : AdminRowController
  scope      :
    user: '=adminRowLarge'
