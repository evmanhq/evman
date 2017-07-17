class EventProperty < ApplicationRecord
  belongs_to :team
  has_many :options, class_name: 'EventPropertyOption', inverse_of: :property, dependent: :destroy, foreign_key: :property_id

  def selected_options(event)
    return [] if new_record?
    return [] if event.properties_assignments.blank?
    values = event.properties_assignments[id.to_s]
    return [] if values.blank?

    # search through array if options are eager loaded
    if options.loaded?
      options.select{ |option| values.include?(option.id.to_s) }
    else
      options.where(id: values)
    end
  end

  def events
    team.events.jsonb_where(:properties_assignments, {id => []})
  end

  private
  after_destroy :clear_event_assignments
  def clear_event_assignments
    events.update_all("properties_assignments = (properties_assignments - '#{id}')")
  end
end
