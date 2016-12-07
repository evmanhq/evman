module OrganizedEventServices
  class EventForm
    include ActiveModel::Model

    def model_name
      ActiveModel::Name.new(self, nil, "EventForm")
    end

    validates :name, presence: true
    validates :language_ids, length: { minimum: 1 }
    validates :organized_event_tshirt_size_ids, length: { minimum: 1 }
    validates :organized_event_difficulty_ids, length: { minimum: 1 }
    validates :organized_event_paper_type_ids, length: { minimum: 1 }
    validates :track_names, length: { minimum: 1 }

    validate do |form|
      organized_event = form.organized_event
      destroyed_tracks = organized_event.tracks.where(name: form.destroyed_track_names).includes(:papers)
      destroyed_tracks.each do |track|
        form.errors.add :base, :track_has_papers, track: track.name if track.papers.any?
      end
    end

    delegate :persisted?, to: :organized_event

    attr_reader :organized_event, :params, :current_user, :current_team
    attr_reader :name, :language_ids, :organized_event_tshirt_size_ids, :organized_event_difficulty_ids,
                :organized_event_paper_type_ids, :track_names, :owner_id, :description, :logo, :remove_logo

    def initialize organized_event, params = {}, current_user = nil, current_team = nil
      @organized_event, @params = organized_event, params
      @current_user, @current_team = current_user, current_team
      raise ArgumentError, 'organized_event is not type of OrganizedEvent' unless organized_event.is_a? OrganizedEvent

      @name                            = params[:name]                            || organized_event.name
      @description                     = params[:description]                     || organized_event.description
      @language_ids                    = params[:language_ids]                    || organized_event.language_ids
      @organized_event_tshirt_size_ids = params[:organized_event_tshirt_size_ids] || organized_event.organized_event_tshirt_size_ids
      @organized_event_difficulty_ids  = params[:organized_event_difficulty_ids]  || organized_event.organized_event_difficulty_ids
      @organized_event_paper_type_ids  = params[:organized_event_paper_type_ids]  || organized_event.organized_event_paper_type_ids
      @track_names                     = params[:track_names]                     || organized_event.tracks.pluck(:name)
      @owner_id                        = params[:owner_id]                        || organized_event.owner_id

      [:language_ids, :organized_event_tshirt_size_ids, :organized_event_difficulty_ids,
       :organized_event_paper_type_ids,  :track_names].each do |attribute|
        stripped = instance_variable_get("@#{attribute}").reject(&:blank?)
        instance_variable_set("@#{attribute}", stripped)
      end
    end

    def languages
      Language.where(id: language_ids)
    end

    def organized_event_tshirt_sizes
      OrganizedEventTshirtSize.where(id: organized_event_tshirt_size_ids)
    end

    def organized_event_difficulties
      OrganizedEventDifficulty.where(id: organized_event_difficulty_ids)
    end

    def organized_event_paper_types
      OrganizedEventPaperType.where(id: organized_event_paper_type_ids)
    end

    def tracks
      track_names.collect do |track_name|
        OrganizedEventTrack.new(name: track_name)
      end
    end

    def owner
      User.where(id: owner_id)
    end

    def submit
      return false if invalid?
      OrganizedEvent.transaction do
        organized_event.lock!
        organized_event.name = name
        organized_event.description = description
        organized_event.language_ids = language_ids
        organized_event.organized_event_tshirt_size_ids = organized_event_tshirt_size_ids
        organized_event.organized_event_difficulty_ids = organized_event_difficulty_ids
        organized_event.organized_event_paper_type_ids = organized_event_paper_type_ids
        organized_event.token ||= SecureRandom.uuid.gsub(/-/,'')
        organized_event.owner_id = owner_id

        organized_event.team = current_team if organized_event.new_record?

        organized_event.save!

        new_track_names.each do |track_name|
          OrganizedEventTrack.create!(organized_event: organized_event, name: track_name)
        end

        organized_event.tracks.where(name: destroyed_track_names).each do |track|
          track.destroy!
        end
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each do |message|
        errors.add :base, message
      end
      false
    end


    def to_model
      organized_event
    end

    def new_track_names
      track_names - organized_event.tracks.pluck(:name)
    end

    def destroyed_track_names
      organized_event.tracks.pluck(:name) - track_names
    end
  end
end