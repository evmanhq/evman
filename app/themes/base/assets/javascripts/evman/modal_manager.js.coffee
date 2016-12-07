class EvMan.ModalManager

  DEFAULTS:
    CLOSE_BUTTON_CLASS: 'modal-close'

  constructor: (modal_container) ->
    @modal_container = $(modal_container)
    @modal_container.data('modal_manager', @)
    @inset = @modal_container.hasClass('inset')
    @modal_stack = []

    @modal_container.on('click.modal-manager', '.'+@DEFAULTS.CLOSE_BUTTON_CLASS, @closeCurrent)
    @modal_container.on('hidden.bs.modal', '.modal', @modalHiding)
    @prepopulate()

  registerModal: (modal) ->
    @modal_stack.push modal
    @modal_stack

  currentModal: ->
    _.last @modal_stack

  open: (modal) ->
    @justHide = true
    @currentModal()?.hide()
    @registerModal modal
    if @inset
      modal.bs_modal_options.backdrop = false
      modal.bs_modal_options.keyboard = false
    modal.container.appendTo(@modal_container)
    modal.show()
    @justHide = false
    $.evman.renderViews()

  closeCurrent: =>
    modal = @modal_stack.pop()
    return unless modal
    modal.hide()
    modal.remove()
    @currentModal()?.show()

  closeAll: ->
    @closeCurrent() while @currentModal()

  modalHiding: (e) =>
    return if @justHide
    modal = $(e.target).data('modal')
    if modal == @currentModal()
      @closeCurrent()

  ######
  prepopulate: ->
    modal_content = @modal_container.find('.modal-prepopulate')
    if modal_content.length
      modal = new EvMan.Modal($(modal_content))
      @open(modal)


