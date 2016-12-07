EvMan.Components.Filterer.FilterTemplates ||= {}

class EvMan.Components.Filterer.FilterTemplates.StringValue
  @type: -> 'string_value'

  FORM_TEMPLATE = """
      <div class="col-md-2">
        <select name="operator">
          {{ _.each(operators, function(operator) { }}
            <option value="{{= operator.value }}" name="operator">{{= operator.label}}</option>
          {{ }); }}
        </select>
      </div>

      <div class="col-md-2">
        <input type="text" name="value" class="form-control" />
      </div>
  """

  constructor: (filterer, options) ->
    @filterer = filterer
    @options = options || {}
    @label = @options.label
    @name = @options.name
    @filter = @options.filter
    @operators = @buildOperators(@options.operators)

  render: (container)->
    template = _.template(FORM_TEMPLATE)
    html = template({operators: @operators})
    container.append(html)

    @operator_select = container.find('select[name=operator]')
    @operator_select.selectize()

    @value_input = container.find('input[name=value]')
    @value_input.keypress (e) =>
      @filterer.submit() if e.which == 13

  toParams: ->
    {
      name: @name
      type: EvMan.Components.Filterer.FilterTemplates.StringValue.type()
      operator: @operator_select?.selectize().val(),
      value: @value_input?.val()
    }

  newFilter: (filter) ->
    new Filter(@, filter)


  buildOperators: (operators) ->
    _.map operators, (operator) => @buildOperator(operator)

  buildOperator: (operator) ->
    if typeof operator is 'string'
      {label: operator, value: operator}
    else
      operator

  class Filter
    TEMPLATE = """
      <div class="btn-group">
         <div class="btn btn-primary cursor-default">{{= label }}</div>
         <div class="btn btn-info cursor-default">{{= operator }}</div>
         <div class="btn btn-primary cursor-default">{{= value }}</div>
         <div class="btn btn-danger remove-button">
           <i class="fa fa-remove"></i>
         </div>
       </div>
    """

    constructor: (template, filter) ->
      @template = template
      @id = ++template.filterer.counter
      @operator = filter.params.operator
      @value = filter.params.value

    render: ->
      template = _.template(TEMPLATE)
      html = $(template({ label: @template.label, operator: @operator, value: @value}))
      remove_button = html.find('.remove-button')
      remove_button.click =>
        @template.filterer.removeFilter(@id)
        @template.filterer.submit()
      html

    toParams: ->
      {
        name: @template.name
        type: EvMan.Components.Filterer.FilterTemplates.StringValue.type()
        operator: @operator,
        value: @value
      }





#[
#  {
#    label: 'Title',
#    name: 'title',
#    type: 'text_value',
#    operators: ['=','~']
#  },
#  {
#    label: 'Title',
#    name: 'title',
#    type: 'text_value',
#    operators: ['=','~']
#  },
#]