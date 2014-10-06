_ = require 'lodash'

resultCalc = require '../lib/result-calc.coffee'
timeTaken  = require '../lib/time-taken.coffee'

module.exports = admin = angular.module 'testlab.admin', [ 'ngResource' ]

addFields = (user) ->
  user.calculatedResult = resultCalc user.questions
  user.timeTaken        = timeTaken user.startedAt, user.finishedAt
  user


admin.factory 'Admin', [ '$resource', ($resource) ->
  $resource 'api/admin', { id: '@id' },
    overview:
      url     : 'api/admin/overview'

    update:
      method  : 'PUT'
      url     : 'api/admin/update/:id'
      transformResponse: (data) ->
        try
          user = JSON.parse data
          user = addFields user
        catch ignored

    users:
      isArray : true
      url     : 'api/admin/users'
      cache   : false
      transformResponse: (data) ->
        try
          parsed = JSON.parse data
          _.map parsed, addFields
        catch ignored

    remove:
      url    : 'api/admin/user/:id'
      method : 'DELETE'
]
