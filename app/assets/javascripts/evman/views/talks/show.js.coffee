EvMan.Views.Talks ||= {}
class EvMan.Views.Talks.Show
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderTagsSelect2()

  renderTagsSelect2: ->
    @container.find('#tag').select2
      placeholder: 'Add new tag'
      minimumInputLength: 1
      multiple: true
      tags: true
      ajax:
        url: '/tags.json'
        dataType: 'json'
        quietMillis: 250
        processResults: (data, page) ->
          {results: data}