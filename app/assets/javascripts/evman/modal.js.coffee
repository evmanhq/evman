class EvMan.Modal
  constructor: (container) ->
    @container = container
    @modal_content = @container.find('.modal-dialog-content')
    @modal_content.data('modal', @)
    @bs_modal_options = {}

  initBsModal: ->
    @modal_content.modal($.extend({}, { show: false }, @bs_modal_options))

  show: ->
    @initBsModal()
    @modal_content.modal('show')

  hide: ->
    @initBsModal()
    @modal_content.modal('hide')

  isVisible: ->
    @modal_content.hasClass('in')

  remove: ->
    @container.remove()