# All new test templates should go here
TEMPLATES =
  'text'     : require './text.tpl.html'
  'checkbox' : require './checkbox.tpl.html'
  'radio'    : require './radio.tpl.html'
  'picture'  : require './picture.tpl.html'
  'code'     : require './code.tpl.html'

module.exports = questionTemplates = angular.module 'testlab.view.question.templates', [
  'ui.codemirror'
]

# Put all the test templates to the cache
# Makes it easier for us to later on include them by template names
questionTemplates.run [ '$templateCache', ($templateCache) ->
  $templateCache.put name, template for name, template of TEMPLATES
]
