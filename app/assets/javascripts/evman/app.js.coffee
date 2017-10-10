class EvMan.App
  init: ->
    @underscoreTemplateSettings()

    $(document).on 'turbolinks:load', =>
      @renderViews()
      @initModalManagers()

  underscoreTemplateSettings: ->
    # Rewrites default settings for tempaltes to use {{= variable }}, {{ evaluate }}, {{- strip_html }}
    _.templateSettings = {
      evaluate: /\{\{([\s\S]+?)\}\}/g,
      interpolate: /\{\{=([\s\S]+?)\}\}/g,
      escape: /\{\{-([\s\S]+?)\}\}/g
    }

  initModalManagers: ->
    @modal_managers = []
    for modal_container in $('.modal-manager-container')
      @modal_managers.push new EvMan.ModalManager(modal_container)

    @modal_manager = @modal_managers[0]

  findModalManager: (element) ->
    element.parents('.modal-manager-container').first().data('modal_manager') || @modal_managers[0]

  renderViews: =>
    for element in $('*[data-js]')
      element = $(element)
      continue unless element.data('js')
      view_class_list = element.data('js').render_class
      options = element.data('js').render_options
      continue unless view_class_list

      view_class_list = view_class_list.split('.').reverse()
      view_class = eval(view_class_list.pop())
      view_class = view_class[view_class_list.pop()] while _.size(view_class_list) > 0 and view_class

      continue unless view_class

      view = new view_class(element, options)
      view.render()

      @globalRender(element)

      element.data('js', null)
      element.attr('js', null)

  globalRender: (container) ->
    container.find('input').each (input) ->
      return if $(input).parents('.vue-template').length > 0
      $(input).iCheck({checkboxClass: 'icheckbox_minimal-blue', radioClass: 'iradio_minimal-blue'})


