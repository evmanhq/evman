EvMan.Views.Expenses ||= {}
class EvMan.Views.Expenses.Form
  constructor: (container, options) ->
    @container = container
    @options = options

  render: ->
    @renderUserSelect2()
    @renderTypeSelect2()
    @renderEventSelect2()
    @renderItemSelect2()

  renderUserSelect2: ->
    @container.find('#expense_user_id').select2()

  renderItemSelect2: ->
    @container.find('#expense_item_id').select2()

  renderTypeSelect2: ->
    @container.find('#expense_expense_type_id').select2()

  renderEventSelect2: ->
    @container.find('#expense_event_id').select2
      placeholder: "Search for event"
      minimumInputLength: 1
      ajax:
        url: @options.events_path
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> { q: term }
        processResults: (data, page) -> { results: data }
      templateResult: (item) ->
        if item.name then item.name + ' (' + item.begins_at + ')' else item.text
      templateSelection: (item) ->
        if item.name then item.name + ' (' + item.begins_at + ')' else item.text
      id: (item) -> item.id

