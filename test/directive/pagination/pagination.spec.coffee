helpers    = require '../../helpers.coffee'
pagination = require '../../../app/scripts/directive/pagination/pagination.coffee'

describe 'pagination', ->
  compile = null
  scope   = null
  html    = '<section class="pagination-sm"
                      data-pagination
                      data-total-items="total"
                      data-current-page="getPage()"
                      data-change="changePage"
                      data-max-items="maxItems"></section>'

  create = (tpl) ->
    el = compile(tpl) scope
    scope.$digest()
    el

  beforeEach helpers.module pagination.name
  beforeEach inject ($compile, $rootScope) ->
    compile = $compile
    scope   = $rootScope.$new()

  it 'should compile to html', ->
    scope.total = 1
    scope.maxItems = 10
    res = create html
    res.children().length.should.be.ok

  it 'should render all the pages if pages nr is lower than max', ->
    scope.total = 5
    scope.maxItems = 10
    res = create html
    res.find('li.page-nr').length.should.eql 5

  it 'should render only max number of items if the nr is higher', ->
    scope.total = 15
    scope.maxItems = 10
    res = create html
    res.find('li.page-nr').length.should.eql 10

  it 'should start the nr count from 1 if page is 0', ->
    scope.total = 15
    scope.maxItems = 10
    scope.getPage = -> 0
    res  = create html
    text = +res.find('li.page-nr').first().text()
    text.should.eql 1

  it 'should have the last nr as 10', ->
    scope.total = 15
    scope.maxItems = 10
    scope.getPage = -> 0
    res  = create html
    text = +res.find('li.page-nr').last().text()
    text.should.eql 10

  it 'should have the last nr as 10', ->
    scope.total = 15
    scope.maxItems = 10
    scope.getPage = -> 0
    res  = create html
    text = +res.find('li.page-nr').last().text()
    text.should.eql 10

  it 'should give the right last item if lastPage is the same as total', ->
    scope.total = 20
    scope.maxItems = 10
    scope.getPage = -> 19
    res  = create html
    text = +res.find('li.page-nr').last().text()
    text.should.eql 20

  it 'should give the right first item if lastPage is same as total', ->
    scope.total = 20
    scope.maxItems = 10
    scope.getPage = -> 19
    res  = create html
    text = +res.find('li.page-nr').first().text()
    text.should.eql 11

  it 'should change the first page according to median value', ->
    scope.total = 20
    scope.maxItems = 10
    scope.getPage = -> 6
    res  = create html
    text = +res.find('li.page-nr').first().text()
    text.should.eql 2

  it 'should change the last page according to median value', ->
    scope.total = 20
    scope.maxItems = 10
    scope.getPage = -> 6
    res  = create html
    text = +res.find('li.page-nr').last().text()
    text.should.eql 11

  it 'should show the correct start numbers if totalItems is lower than maxItems', ->
    scope.total = 4
    scope.maxItems = 10
    scope.getPage = -> 1
    res  = create html
    text = +res.find('li.page-nr').first().text()
    text.should.eql 1

  it 'should show the correct end numbers if totalItems is lower than maxItems', ->
    scope.total = 4
    scope.maxItems = 10
    scope.getPage = -> 1
    res  = create html
    text = +res.find('li.page-nr').last().text()
    text.should.eql 4
