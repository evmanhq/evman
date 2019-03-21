class Inputs::PropertyAssignment < Types::BaseInputObject
  argument :id, ID, required: true
  argument :values, [ID], required: false
end

class Inputs::EventAttributes < Types::BaseInputObject
  description "Attributes for creating or updating an event"

  argument :approved, Boolean, required: false
  argument :committed, Boolean, required: false
  argument :archived, Boolean, required: false


  # Strings
  [:name, :location, :sponsorship, :cfp_url, :url, :url2, :url3, :description].each do |string_column|
    argument string_column, String, required: false
  end

  # Integers
  [:event_type_id].each do |string_column|
    argument string_column, Integer, required: false
  end

  # Dates
  [:begins_at, :ends_at, :cfp_date, :sponsorship_date].each do |date_column|
    argument date_column, GraphQL::Types::ISO8601DateTime, required: false
  end

  argument :properties_assignments, [Inputs::PropertyAssignment], required: false

  # argument :begins_at, String, required: false
end
