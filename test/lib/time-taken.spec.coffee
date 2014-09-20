timeTaken = require '../../app/scripts/lib/time-taken.coffee'
assert    = require 'assert'

addMinutes = (start, min) ->
  new Date(start.getTime() + min * 60000)


describe 'time taken lib', ->
  it 'should return undefined if no params are given', ->
    assert timeTaken() is undefined

  it 'should return the time in minutes (singles)', ->
    startedAt  = new Date()
    finishedAt = addMinutes startedAt, 2
    timeTaken(startedAt, finishedAt).should.eql 2

  it 'should return the time in minutes (hours)', ->
    startedAt  = new Date()
    finishedAt = addMinutes startedAt, 90
    timeTaken(startedAt, finishedAt).should.eql 90

  it 'should return 0 if there is no difference', ->
    startedAt  = new Date()
    timeTaken(startedAt, startedAt).should.eql 0

