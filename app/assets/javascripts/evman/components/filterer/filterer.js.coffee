class EvMan.Components.Filterer

  TEMPLATE = """
    <div class="row">
      <div class="col-md-2">
        <select name="filterer_select">
          <option value=''>Filter</option>
          {{ _.each(filter_templates, function(template) { }}
            <option value="{{= template.name }}">{{= template.label}}</option>
          {{ }); }}
        </select>
      </div>

      <div class="filter-templates-container"></div>

      <div class="col-md-1">
        <div class="filterer-submit btn btn-primary">Filter</div>
      </div>
    </div>

    <div class="filters-container btn-toolbar"></div>
  """

  constructor: (filter_templates, filters, options) ->
    @counter = 0
    @filter_templates = @buildFilterTemplates(filter_templates)
    @filters = @buildFilters(filters)
    @options = options || {}
    @container = @options.container
    @url = @options.url

  render: ->
    template = _.template(TEMPLATE)
    html = $(template({filter_templates: @filter_templates}))
    @container.html(html)
    select = @container.find('select[name=filterer_select]')
    filter_templates_container = @container.find('.filter-templates-container')
    submit_button = @container.find('.filterer-submit')

    select.selectize
      onChange: (value) =>
        selected_filter_template = _.find(@filter_templates, (f) -> f.name == value)
        filter_templates_container.empty()
        if selected_filter_template
          html = selected_filter_template.render(filter_templates_container)
          @selected_filter_template = selected_filter_template

    submit_button.on 'click', @submit

    filters_container = @container.find('.filters-container')
    filters_container.empty()
    for filter in @filters
      html = filter.render()
      filters_container.append(html)



  submit: =>
    filters = _.map(@filters, (f) -> f.toParams())
    filters.push(@selected_filter_template.toParams()) if @selected_filter_template
    url = @url + "?" +$.param({ filters: filters })
    Turbolinks.visit(url)

  removeFilter: (id) ->
    @filters = _.reject @filters, (f) -> f.id == id


  buildFilterTemplates: (templates) ->
    _.map templates, (template) => @buildFilterTemplate(template)

  buildFilterTemplate: (filter) ->
    klass = @filterTemplateClass(filter.type)
    new klass(@, filter)

  filterTemplateClass: (type) ->
    _.find(EvMan.Components.Filterer.FilterTemplates, (f) -> f.type() == type)

  buildFilters: (filters) ->
    _.map filters, (filter) => @buildFilter(filter)

  buildFilter: (filter) ->
    template = _.find @filter_templates, (t) => t.name == filter.name
    template.newFilter(filter)





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