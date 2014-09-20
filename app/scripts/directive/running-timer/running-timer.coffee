moment       = require 'moment'

module.exports = runningTimer = angular.module 'testlab.view.runningtimer', [
  'classy'
]

formatMs = (ms) ->
  moment(ms).format 'mm:ss'

toMin = (ms) ->
  ms / 60 / 1000

runningTimer.directive 'runningTimer', ->
  template: require './running-timer.tpl.html'
  scope:
    user: '=runningTimer'

  controller: runningTimer.classy.controller
    inject: [
      '$scope'
      '$timeout'
    ]

    watch:
      user: 'updateRunningTimer'

    isFinished: ->
      @$scope.user?.finishedAt or @$scope.user?.timeLeft is 0

    isStarted: ->
      @$scope.user?.startedAt

    updateRunningTimer: ->
      return if @timerId
      return if @isFinished()
      return unless @$scope.user
      @$scope.user.timeLeft -= 1000
      @timerId = @$timeout =>
        @timerId = null
        @updateRunningTimer()
      , 1000

    getFormattedTotal: (time) ->
      return unless @isStarted()
      formatMs time

    getFormattedDuration: (total, left) ->
      return unless @isStarted()
      time = total - left
      formatMs time or 0

    isCritical: (ms) ->
      toMin(ms) <= 2

    isWarning: (ms) ->
      toMin(ms) <= 8
