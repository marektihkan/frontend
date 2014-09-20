module.exports = user = angular.module 'testlab.user', [ 'ngResource' ]

class CachedUser
  deffered: null
  constructor: ($resource, @$q) ->
    @User = $resource '/api/user', { },
      start:
        method: 'PUT'
        url: '/api/user/start'

      finish:
        method: 'POST'
        url: '/api/user/finish'

  fetch: =>
    @deffered = @$q.defer()
    @User.get @deffered.resolve, @deffered.reject
    @deffered

  get: (successcb, errorcb) =>
    { promise } = @deffered or @fetch()
    rawPromise = promise.then successcb, errorcb
    rawPromise.$promise = promise
    rawPromise

  start: -> @User.start arguments...

  finish: -> @User.finish arguments...


user.service 'User', [ '$resource', '$q', CachedUser ]
