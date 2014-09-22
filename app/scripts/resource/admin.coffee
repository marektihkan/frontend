_ = require 'lodash'

resultCalc = require '../lib/result-calc.coffee'
timeTaken  = require '../lib/time-taken.coffee'

module.exports = admin = angular.module 'testlab.admin', [ 'ngResource' ]

admin.factory 'Admin', [ '$resource', ($resource) ->
  $resource 'api/admin', { },
    users:
      isArray: true
      url: 'api/admin/users'
      cache: false
      transformResponse: (data) ->
        parsed = JSON.parse data
        _.map parsed, (user) ->
          user.calculatedResult = resultCalc user.questions
          user.timeTaken        = timeTaken user.startedAt, user.finishedAt
          user

    overview:
      url: 'api/admin/overview'
]
