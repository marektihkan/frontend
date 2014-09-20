helpers      = require '../../helpers.coffee'
orderControl = require '../../../app/scripts/directive/order-control/order-control.coffee'

describe 'order control', ->
  compile = null
  scope   = null
  html    = '<div data-order-control="orderExpression"
                  data-keys="keys">'

  create = (tpl) ->
    el = compile(tpl) scope
    scope.$digest()
    el

  beforeEach helpers.module orderControl.name
  beforeEach inject ($compile, $rootScope) ->
    compile = $compile
    scope   = $rootScope.$new()

  it 'should compile to html', ->
    res = create html
    res.should.be.ok

  describe '#addToOrder', ->
    it 'should add elements to orderExpression list', ->
      list = []
      scope.$apply -> scope.orderExpression = list
      isolateScope = create(html).isolateScope()
      isolateScope.addToOrder 'test'
      list[0].should.eql 'test'

  describe '#removeFromOrder', ->
    it 'should remove elements from list', ->
      list = [ 'test' ]
      scope.$apply -> scope.orderExpression = list
      isolateScope = create(html).isolateScope()
      isolateScope.removeFromOrder 'test'
      list.should.eql []

  describe '#removeExcess', ->
    it 'should remove ! if its in the beginning', ->
      isolateScope = create(html).isolateScope()
      res = isolateScope.removeExcess '!test'
      res.should.eql 'test'

    it 'should not remove anything if its ok', ->
      isolateScope = create(html).isolateScope()
      res = isolateScope.removeExcess 'test'
      res.should.eql 'test'

  describe '#isAsc', ->
    it 'should return true if it starts with !', ->
      isolateScope = create(html).isolateScope()
      res = isolateScope.isAsc '!test'
      res.should.be.ok

    it 'should return false if it does not start with !', ->
      isolateScope = create(html).isolateScope()
      res = isolateScope.isAsc 'test'
      res.should.not.be.ok

  describe '#orderFilterFn', ->
    it 'should return false if element is in the list', ->
      list = [ 'test' ]
      scope.$apply -> scope.orderExpression = list
      isolateScope = create(html).isolateScope()
      res = isolateScope.orderFilterFn 'test'
      res.should.not.be.ok

    it 'should return false if opposite is in the list', ->
      list = [ '!test' ]
      scope.$apply -> scope.orderExpression = list
      isolateScope = create(html).isolateScope()
      res = isolateScope.orderFilterFn 'test'
      res.should.not.be.ok

    it 'should return true if element is not in the list', ->
      list = [ 'test' ]
      scope.$apply -> scope.orderExpression = list
      isolateScope = create(html).isolateScope()
      res = isolateScope.orderFilterFn 'test does not exist'
      res.should.be.ok

  describe '#toggleAsc', ->
    it 'should add ! at the beginning of item', ->
      list = [ 'test' ]
      scope.$apply -> scope.orderExpression = list
      isolateScope = create(html).isolateScope()
      isolateScope.toggleAsc 'test'
      list[0].should.eql '!test'

    it 'should remove ! from the beginning of item', ->
      list = [ '!test' ]
      scope.$apply -> scope.orderExpression = list
      isolateScope = create(html).isolateScope()
      isolateScope.toggleAsc '!test'
      list[0].should.eql 'test'

    it 'should keep the index the same', ->
      list = [ 'hello', '!test', 'wat' ]
      scope.$apply -> scope.orderExpression = list
      isolateScope = create(html).isolateScope()
      isolateScope.toggleAsc '!test'
      list[1].should.eql 'test'
