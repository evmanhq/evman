class EventPropertyOption < ApplicationRecord
  belongs_to :property, class_name: 'EventProperty', inverse_of: :options
  has_one :team, through: :property

  def events
    team.events.jsonb_where(:properties_assignments, { property.id.to_s => [id.to_s] })
  end

  private
  after_destroy :clear_event_assignments
  def clear_event_assignments
    events.update_all <<-TEXT
      properties_assignments = jsonb_set(properties_assignments, '{#{property.id}}',
        (properties_assignments -> '#{property.id}') - '#{id}'  
      )
    TEXT
  end
end
