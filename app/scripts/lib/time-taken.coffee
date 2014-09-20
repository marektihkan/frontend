moment = require 'moment'

module.exports = (startedAt, finishedAt) ->
  return if not startedAt or not finishedAt
  started  = moment startedAt
  finished = moment finishedAt
  duration = moment.duration finished.diff started
  # Minutes range is 0-60, if over that then we need to manually add hours
  duration.hours() * 60 + duration.minutes()
