## Custom confirm dialog

# Allows whatever action that is going to happen, considering data-confirm attribute
# @returns true if data-confirm object is confirmed
$.rails.allowAction = (element) ->
  return true unless element.data('confirm')
  if element.data('confirm').confirmed
    setTimeout (-> element.data('confirm').confirmed = false), 500
    return true

  $.rails.confirmDialog element
  false

# Renders confirm dialog box
$.rails.confirmDialog = (element) ->
  message = element.data('confirm')
  modal_content = $.rails.confirmDialogTemplate(title: message.title, body: message.question)
  modal = new EvMan.Modal($(modal_content))
  modal.container.on 'click.modal-manager', '.modal-confirm-yes', -> $.rails.confirmed(element)
  $.evman.findModalManager(element).open modal

# Sets confirmed state to the data-confirm object of the element and triggers click.rails again
$.rails.confirmed = (element) ->
  $.evman.findModalManager(element).closeCurrent()
  element.data('confirm').confirmed = true
  if element.prop('tagName') == "FORM"
    element.trigger 'submit.rails'
  else
    element.trigger 'click.rails'

# Modal Windows - data-modal="true"
$.rails.handleModal = (element) ->
  modal_manager = $.evman.findModalManager(element)
  if element.is('form')
    url = element.attr('action')
    method = element.attr('method')
    data = $(element[0]).serializeArray()
  else
    url = $.rails.href(element) || element.data('modal-url')
    method = element.data('modal').method
    data = element.data('params') || null

  modalRenderType = element.data('modal').render_type || 'advance'

  dataType = element.data('type') || ($.ajaxSettings && $.ajaxSettings.dataType)
  withCredentials = element.data('with-credentials') || null

  options = {
    type: method || 'GET'
    data: data
    dataType: dataType
    # stopping the "ajax:beforeSend" event will cancel the ajax request
    beforeSend: (xhr, settings) ->
      xhr.setRequestHeader('X-EvMan-Modal','true')
      if (settings.dataType == undefined)
        xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script)
      if ($.rails.fire(element, 'ajax:beforeSend', [xhr, settings]))
        element.trigger('ajax:send', xhr)
      else
        false
    success: (data, status, xhr) ->
      element.trigger('ajax:success', [data, status, xhr])
      $.rails.renderModal(modal_manager, data, modalRenderType) if /text\/html/.test(xhr.getResponseHeader('Content-type'))
    complete: (xhr, status) ->
      element.trigger('ajax:complete', [xhr, status])
    error: (xhr, status, error) ->
      element.trigger('ajax:error', [xhr, status, error])
      switch xhr.status
        when 403
          $.rails.renderModal(modal_manager, xhr.responseText, modalRenderType)
        else
          content = $.rails.errorModalTemplate(title: error, body: xhr.responseText)
          $.rails.renderModal(modal_manager, content)
    crossDomain: $.rails.isCrossDomain(url)
  }

  if withCredentials
    options.xhrFields = {
      withCredentials: withCredentials
    }

  options.url = url if url

  $.rails.ajax(options)

$.rails.renderModal = (modal_manager, content, modalRenderType) ->
  modal = new EvMan.Modal($(content))
  modal_manager.closeCurrent() if modalRenderType == 'replace'
  modal_manager.open modal

$.rails.modalLinkSelector = 'a[data-modal]' # ,*:not(a)[data-modal][data-modal-url]
$.rails.modalFormSelector = 'form[data-modal]'

$(document).on 'turbolinks:load', ->
  if $('#confirm-dialog-template')[0]
    $.rails.confirmDialogTemplate = _.template($('#confirm-dialog-template').html())
  if $('#error-modal-template')[0]
    $.rails.errorModalTemplate = _.template($('#error-modal-template').html())

$(document).on 'click.rails.modal', $.rails.modalLinkSelector, (e) ->
  link = $(this)
  return $.rails.stopEverything(e) unless $.rails.allowAction(link)

  $.rails.handleModal(link)
  false

$(document).on 'submit.rails.modal', $.rails.modalFormSelector, (e) ->
  form = $(this)
  return $.rails.stopEverything(e) unless $.rails.allowAction(form)

  $.rails.handleModal(form)
  false

$(document).on 'turbolinks:before-render', ->
  for modal_manager in $.evman.modal_managers
    modal_manager.closeAll()