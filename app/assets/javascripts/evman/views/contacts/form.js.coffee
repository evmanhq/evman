EvMan.Views.Contacts ||= {}
class EvMan.Views.Contacts.Form
  SEARCH_DELAY = 300
  constructor: (container, options) ->
    @container = container
    @options = options
    @fields = {
      name: @container.find('#contact_name'),
      email: @container.find('#contact_email')
    }

    @contact_suggestion_container = @container.find('.contact_suggestions')

  render: ->
    @registerWatcher() if !!@options.contacts_path and @options.suggest_contacts

  registerWatcher: ->
    @fields.name.keyup(@searchForContact)
    @fields.name.blur(@searchForContact)
    @fields.email.keyup(@searchForContact)
    @fields.email.keyup(@searchForContact)

  searchForContact: =>
    clearTimeout(@searchTimer) if @searchTimer
    @searchTimer = setTimeout(@performSearch, SEARCH_DELAY)

  performSearch: =>
    console.log('Name: ', @fields.name.val(), ' Email: ', @fields.email.val())

    $.ajax
      url: @options.contacts_path
      data:
        name: @fields.name.val()
        email: @fields.email.val()
      type: 'GET'
      success: @renderSuggestions

  renderSuggestions: (res)=>
    @contact_suggestion_container.html(res)
    @contact_suggestion_container.on 'click', '.close_suggestions', =>
      @contact_suggestion_container.empty()
      clearTimeout(@searchTimer) if @searchTimer
