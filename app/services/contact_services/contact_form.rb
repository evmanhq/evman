module ContactServices
  class ContactForm
    include ActiveModel::Model

    def model_name
      ActiveModel::Name.new(self, nil, "ContactForm")
    end

    validates :name, presence: true

    delegate :persisted?, :new_record?, to: :contact

    attr_reader :contact, :params
    attr_reader :name, :email, :job_title, :phone_office, :phone_cell
    attr_reader :event
    def initialize contact, params = {}
      @contact, @params = contact, params
      raise ArgumentError, 'contact is not type of Contact' unless contact.is_a? Contact

      @name         = params[:name]         || contact.name
      @email        = params[:email]        || contact.email
      @job_title    = params[:job_title]    || contact.job_title
      @phone_office = params[:phone_office] || contact.phone_office
      @phone_cell   = params[:phone_cell]   || contact.phone_cell
      @event    = Event.where(id: params[:event_id]).first
    end

    def event_id
      return nil unless event
      event.id
    end

    def contact_id
      contact.id
    end

    def submit
      return false if invalid?
      Contact.transaction do
        contact.name = name
        contact.email = email
        contact.job_title = job_title
        contact.phone_office = phone_office
        contact.phone_cell = phone_cell
        contact.save!

        if event and contact.events.where(id: event.id).none?
          contact.events << event
        end
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each do |message|
        errors.add :base, message
      end
      false
    end

    def redirect_model
      return event if event
      contact
    end

    def to_model
      contact
    end
  end
end