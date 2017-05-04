EvMan.Views.Forms ||= {}
class EvMan.Views.Forms.Edit
  FIELD_TYPES: [
    { name: 'text', label: 'Short text', icon: 'fa-align-left' },
    { name: 'text-area', label: 'Long text', icon: 'fa-align-justify'},
    { name: 'multiple-choice', label: 'Multiple choice', icon: 'fa-dot-circle-o' },
    { name: 'checkboxes', label: 'Checkboxes', icon: 'fa-check-square' },
    { name: 'dropdown', label: 'Dropdown', icon: 'fa-chevron-circle-down' }
  ]

  SAMPLE_FIELDS: [
    {
      data: {
        id: 1,
        type: @::FIELD_TYPES[2],
        label: 'Did Red Hatters from other teams help at the booth? If so, what teams?',
        required: false,
        collapsed: false,
        choices: [{ id: 1, value: 'Alfa' }, { id: 2, value: 'Beta' }]
      }
    },
    {
      data: {
        id: 2,
        type: @::FIELD_TYPES[1],
        label: 'Are there other teams we should invite if we sponsor this event in the future?',
        required: false,
        collapsed: true,
        choices: []
      }
    },
    {
      data: {
        id: 3,
        type: @::FIELD_TYPES[4],
        label: 'What swag did we give out? What was the response from attendees?',
        required: false,
        collapsed: true,
        choices: []
      }
    },
  ]
  DEFAULT_FIELD: (ext)->
    _.extend({
      type:  @FIELD_TYPES[0]
      label: ''
      required: false
      collapsed: false,
      choices: []
    }, ext)


  constructor: (container) ->
    @container = container
    @form_builder = @container.find('.form-builder')
    @form_builder_template = @container.find('#form_builder_template')
    @form_builder_field_template = @container.find('#form_builder_field_template')

  render: ->
    # Disable form submission by pressing enter
    @container.keypress (e) ->
      e.preventDefault() if e.keyCode == 13
    $view = this


    window.vueapp = new Vue(
      el: $view.form_builder[0]
      data:
        fields: @builderData() # @SAMPLE_FIELDS

      components:
        'form-builder': $view.FormBuilder()


    )
  builderData: () ->
    return [] unless @form_builder.data('builder')?.fields
    data = @form_builder.data('builder').fields
    data = _.map data, (field, index) =>
      field.id = index + 1
      field.type = _.find @FIELD_TYPES, (ft) -> ft.name == field.type
      field.collapsed = true
      field.choices ||= []
      field.choices = _.map field.choices, (choice, index) -> { id: index + 1, value: choice }

      { data: field}

    console.log data
    data

  FormBuilder: ->
    $view = this
    {
      template: @form_builder_template.html()
      props:
        fields_data: Array
        name: String

      components:
        'form-builder-field': $view.FieldComponent()

      data: () ->
        fields: @fields_data

      methods:
        addField: () ->
          newId = 1 if @fields.length == 0
          newId ||= _.max(@fields, ((f) ->  f.data.id )).data.id + 1
          @fields.push
            data: $view.DEFAULT_FIELD(id: newId)

        removeField: (field) ->
          index = @fields.indexOf(field)
          @fields.splice(index, 1) if index >= 0

        moveUp: (field) ->
          oldIndex = this.fields.indexOf(field)
          newIndex = oldIndex - 1

          return if newIndex < 0
          @fields.splice(newIndex, 0, @fields.splice(oldIndex, 1)[0])

        moveDown: (field) ->
          oldIndex = this.fields.indexOf(field)
          newIndex = oldIndex + 1

          @fields.splice(newIndex, 0, @fields.splice(oldIndex, 1)[0])
    }


  FieldComponent: ->
    $view = this
    {
      template: @form_builder_field_template.html()
      props:
        value: Object
        builder_name: String

      data: () ->
        _.extend @value,
          validations:
            label: true

      methods:
        toggle: () ->
          @collapsed = !@collapsed;

        createChoice: (e) ->
          value = e.target.value.trim()
          newId = 1 if @choices.length == 0
          newId ||= _.max(@choices, ((c) -> c.id)).id + 1
          @choices.push { value: value, id: newId }
          Vue.nextTick => @$refs["choice_#{newId}"][0].focus()
          e.target.value = ''

        choiceBlur: (choice) ->
          return unless choice.value.trim() == ''
          @deleteChoice(choice)

        deleteChoice: (choice) ->
          index = @choices.indexOf(choice)
          @choices.splice(index, 1)

        focusNext: (choice) ->
          lastId = _.max(@choices, ((c) -> c.id)).id
          if choice.id == lastId
            Vue.nextTick => @$refs.new_choice.focus()
          else
            Vue.nextTick => @$refs["choice_#{choice.id+1}"][0].focus()
        buildName: (name, multiple) ->
          base = "#{@builder_name}[fields][][#{name}]"
          base += "[]" if multiple
          base
        updateType: (type) ->
          @$refs.type.value = type

        validationClass: (field) ->
          "has-danger" unless @validations[field]



      computed:
        types: () ->
          $view.FIELD_TYPES

        hasChoices: () ->
          @type.name in ['multiple-choice', 'checkboxes', 'dropdown']

        valid: () ->
          _.every @validations, (value) -> value

      watch:
        type: (newValue, oldValue) ->
          @updateType newValue.name

        label: (newValue, oldValue) ->
          @validations.label = newValue.trim() != ''

      mounted: () ->
        @updateType @type.name
    }


# Vytvorit nieco ako VueForm, co bude zastresovat pripady pri odosielani vue formulara