module EventsHelper
  def event_properties_form_definition
    event_properties = current_team.event_properties.order(position: :asc).includes(:options)

    event_properties.as_json(only: [:id, :name, :restrictions, :behaviour, :required],
                             include: {
                                 options: {
                                     only: [:id, :name, :restrictions]
                                 }
                             })
  end
end
