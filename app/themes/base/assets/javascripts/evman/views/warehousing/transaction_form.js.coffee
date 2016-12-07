EvMan.Views.Warehousing ||= {}
class EvMan.Views.Warehousing.TransactionForm
  constructor: (container, options) ->
    @container = container
    @options = options


  render: ->
    @renderEventSelect2()
    @rednerBatchesSelect2()

  renderEventSelect2: ->
    @container.find('#warehouse_transaction_event_id').select2
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

  rednerBatchesSelect2: ->
    @container.find('#warehouse_transaction_batch_id').select2
      placeholder: "Search for warehouse item"
      minimumInputLength: 1
      ajax:
        url: @options.batches_path
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> { q: term, only_available: true }
        processResults: (data, page) -> { results: data }
      templateResult: (item) ->
        if item.label then item.label else item.text
      templateSelection: (item) ->
        if item.label then item.label else item.text
      id: (item) -> item.id