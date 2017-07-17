module ContactServices
  class EventAssigner
    include ActiveModel::Model

    attr_reader :contact, :event
    def initialize contact: nil, event: nil
      @contact, @event = contact, event
      raise ArgumenteError, 'missing arguments' if contact.blank? or event.blank?
    end

    def perform
      return false if invalid?
      if contact.events.where(id: event.id).none?
        contact.events << event
      end
      true
    end
  end
end