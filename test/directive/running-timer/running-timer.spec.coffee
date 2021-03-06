helpers = require '../../helpers.coffee'
timer   = require '../../../app/scripts/directive/running-timer/running-timer.coffee'

sinon = require 'sinon'

describe 'running timer', ->
  compile = null
  scope   = null
  html    = '<div running-timer="user"></div>'

  create = (tpl) ->
    el = compile(tpl) scope
    scope.$digest()
    el

  beforeEach helpers.module timer.name
  beforeEach inject ($compile, $rootScope) ->
    compile = $compile
    scope   = $rootScope.$new()

  it 'should compile to html', ->
    elm = create html
    elm.should.be.ok

  it 'should not render anything if user is not set', ->
    elm = create html
    elm.children().length.should.be.not.ok

  it 'should not render anything if the user has not started the test', ->
    elm = create html
    scope.$apply -> scope.user = startedAt: null
    elm.children().length.should.be.not.ok

  it 'should not render anything if the user has finished the test', ->
    elm = create html
    scope.$apply -> scope.user = finishedAt: new Date()
    elm.children().length.should.be.not.ok

  it 'should render if user is has started the test', ->
    elm = create html
    scope.$apply -> scope.user = startedAt: new Date()
    elm.children().length.should.be.ok

  describe 'state notifiers', ->
    element = null
    scope   = null
    beforeEach inject ->
      scope.$apply -> scope.user = startedAt: new Date()
      element = create html
      scope = element.isolateScope()

    it 'should be critical if there are less than 2 minutes to go', ->
      res = scope.isCritical 1*60*1000
      res.should.be.ok

    it 'should not be critical if there are more than 2minutes', ->
      res = scope.isCritical 2.5*60*1000
      res.should.not.be.ok

    it 'should be warned if there are less than 8 minutes to go', ->
      res = scope.isWarning 8*60*1000
      res.should.be.ok

    it 'should not be warned if there are more than 8 minutes', ->
      res = scope.isWarning 9*60*1000
      res.should.not.be.ok

