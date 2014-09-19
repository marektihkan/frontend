userResource  = require '../../resource/user.coffee'
adminResource = require '../../resource/admin.coffee'

module.exports = smallProfile = angular.module 'testlab.view.smallprofile', [
  userResource.name
  adminResource.name
  'classy'
]

smallProfile.directive 'smallProfile', ->
  template: require './small-profile.tpl.html'
  controller: smallProfile.classy.controller
    inject: [
      '$scope'
      'User'
      'Admin'
    ]

    init: ->
      @User.get (user) =>
        @$scope.overview = @Admin.overview() if user.admin
        @$scope.user     = user

