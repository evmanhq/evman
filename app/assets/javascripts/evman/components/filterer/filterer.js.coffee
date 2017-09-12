class EvMan.Components.Filterer
  constructor: (element, options) ->
    @element = $(element)
    @definition = options.definition
    @payload = options.payload

    @container = $('<div></div>')
    @container.html(@element.html())

    @element.empty()
    @element.append(@container)

    @filterer_template = $('#filterer_template')
    @constrain_template = $('#filterer_constrain_template')

  render: () ->
    $view = this

    new Vue(
      el: @container[0]
      data:
        definition: @definition
        constrains: @payload.constrains
      components:
        'filterer': $view.Filterer()
    )

  Filterer: ->
    $view = this
    {
      template: @filterer_template.html()
      props:
        constrains_data: Array
        definition: Array

      components:
        'constrain': $view.Constrain()

      data: () ->
        constrains: _.map(@constrains_data, (data) =>
          {
            data: _.extend(data, { id: @newConstrainId() })
          }
        )

      methods:
        addConstrain: ->
          definition = @definition[0]
          @constrains.push
            data:
              id: @newConstrainId()
              name: definition.name,
              condition: definition.conditions[0].name
              values: []

        newConstrainId: ->
          max_id = _.max(_.map(@constrains, (c) -> c.data.id))
          max_id = 0 if !max_id or max_id == -Infinity
          max_id + 1
    }

  Constrain: ->
    {
      template: @constrain_template.html()
      props:
        value: Object
        field_definitions: Array

      data: () ->
        _.extend @value,
          options: []

      computed:
        selected_field: ->
          _.find @field_definitions, (d) => d.name == @name

        selected_condition: ->
          _.find @selected_field.conditions, (c) => c.name == @condition

        selected_values: ->
          _.filter @options, (o) => @values.includes(o.value)

      watch:
        selected_field: ->
          @options = @selected_field.options
          @condition = @selected_field.conditions[0].name
          @values = []

      methods:
        selectField: (option) ->
          @name = option.name

        selectCondition: (option) ->
          @condition = option.name

        setValue: (event) ->
          @values = [event.target.value]

        setValues: (selected) ->
          @values = _.map(selected, (o) -> o.value)

      beforeMount: ->
        @options = @selected_field.options

    }



