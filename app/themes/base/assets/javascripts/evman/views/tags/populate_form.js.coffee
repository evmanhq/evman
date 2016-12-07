EvMan.Views.Tags ||= {}
class EvMan.Views.Tags.PopulateForm
  constructor: (container, options) ->
    @container = container
    @options = options || {}

  render: ->
    @renderSelectize()

  renderSelectize: ->
    select_selector = @options.select_selector || '#populate_form_tag_names'
    select = @container.find(select_selector)
    select.selectize
      plugins: ['remove_button']
      delimiter: ','
      valueField: 'text'
      labelField: 'text'
      persist: false
      create: (input) ->
        { value: input, text: input }