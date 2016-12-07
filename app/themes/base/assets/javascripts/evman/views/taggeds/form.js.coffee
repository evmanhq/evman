EvMan.Views.Taggeds ||= {}
class EvMan.Views.Taggeds.Form
  constructor: (container, options) ->
    @container = container
    @options = options || {}

  render: ->
    @renderSelectize()

  renderSelectize: ->
    select_selector = @options.select_selector || '#taggeds_form_tag_names'
    select = @container.find(select_selector)
    select.selectize
      plugins: ['remove_button']
      delimiter: ','
      valueField: 'text'
      labelField: 'text'
      preload: true
      persist: false
      create: (input) ->
        { value: input, text: input }
      load: (query, callback) ->
        $.ajax
          url: '/tags.json'
          data:
            q: query
          type: 'GET'
          error: () -> callback()
          success: (res) -> callback(res)