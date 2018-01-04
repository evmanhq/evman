module EventPropertyServices
  class EventValidator < ActiveModel::Validator
    def validate(event)
      team = event.team
      return true unless team
      team.event_properties.each do |event_property|
        next unless event_property.required
        next unless event_property.blank_on_event?(event)
        event.errors.add :base, :event_property_blank, event_property: event_property.name
      end
    end
  end
end