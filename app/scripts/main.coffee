modules = [
  require './init.coffee'
  require './view/login/login.coffee'
  require './view/profile/profile.coffee'
  require './view/questions/questions.coffee'
  require './view/result/result.coffee'
  require './view/admin/admin.coffee'

  require './directive/breadcrumb/breadcrumb.coffee'
  require './directive/small-profile/small-profile.coffee'
].map (mod) -> mod.name

angular.bootstrap document, modules
