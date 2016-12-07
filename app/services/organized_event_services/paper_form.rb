module OrganizedEventServices
  class PaperForm
    include ActiveModel::Model

    Speaker = Struct.new(:email, :label, :primary, :tshirt_size_id)

    def model_name
      ActiveModel::Name.new(self, nil, "PaperForm")
    end

    validates :title, presence: true
    validates :abstract, presence: true
    validates :language_id, presence: true
    validates :difficulty_id, presence: true
    validates :paper_type_id, presence: true
    validates :track_id, presence: true
    validates :speakers, length: { minimum: 1 }

    validate do |paper_form|

      # Speakers
      speakers = paper_form.speakers
      speakers.each do |speaker|
        paper_form.errors.add :base, :speakers_email_blank if speaker.email.blank?
        paper_form.errors.add :base, :speakers_tshirt_size_blank if speaker.tshirt_size_id.blank?
      end

      user_counts = speakers.inject(Hash.new(0)) do |counts, speaker|
        counts[speaker.email] += 1 if speaker.email.present?
        user = find_user(speaker.email)
        counts[user.id] += 1 if user
        counts
      end

      paper_form.errors.add :base, :restrict_repeating_speakers if user_counts.values.any?{|x| x > 1}

      primary_speakers_count = speakers.select{|s| s.primary }.count
      paper_form.errors.add :base, :exactly_one_primary_speaker_required if primary_speakers_count != 1

    end

    delegate :persisted?, to: :paper
    delegate :organized_event, to: :track
    delegate :tag_names, :tags, to: :taggeds_form

    attr_reader :paper, :params
    attr_reader :title, :language_id, :difficulty_id, :track_id, :paper_type_id, :speakers, :abstract,
                :additional_notes, :taggeds_form

    def initialize paper, params = {}, organized_event = nil
      @paper, @params = paper, params
      @organized_event = organized_event
      raise ArgumentError, 'paper is not type of OrganizedEventPaper' unless paper.is_a? OrganizedEventPaper

      @title            = params[:title]                           || paper.title
      @language_id      = params[:language_id]                     || paper.language_id
      @difficulty_id    = params[:difficulty_id]                   || paper.difficulty_id
      @track_id         = params[:track_id]                        || paper.track_id
      @paper_type_id    = params[:paper_type_id]                   || paper.paper_type_id
      @abstract         = params[:abstract]                        || paper.abstract
      @additional_notes = params[:additional_notes]                || paper.additional_notes
      @speakers         = build_speakers_params(params[:speakers]) || build_speakers_model(paper.speakers)
      @taggeds_form     = TaggedServices::Form.new(paper, params.slice(:tag_names))
      
      @speakers.first.primary = true if @speakers.size == 1
    end

    def organized_event
      @organized_event || track.try(:organized_event)
    end

    def language
      Language.where(id: language_id).first
    end

    def track
      OrganizedEventTrack.where(id: track_id).first
    end

    def build_speakers_params params
      return unless params
      params.values.collect do |speaker|
        user = UserEmail.where(email: speaker[:email]).first.try(:user)
        label = user ? "#{user.name} (#{user.email})" : speaker[:email]
        Speaker.new(speaker[:email], label, speaker[:primary].present?, speaker[:tshirt_size_id])
      end
    end

    def build_speakers_model speakers
      speakers.collect do |speaker|
        label = "#{speaker.user.name} (#{speaker.user.email})"
        Speaker.new(speaker.user.email, label, speaker.primary, speaker.tshirt_size_id)
      end
    end

    def submit
      return false if invalid?
      OrganizedEventPaper.transaction do
        paper.lock!
        paper.title = title
        paper.language_id = language_id
        paper.difficulty_id = difficulty_id
        paper.paper_type_id = paper_type_id
        paper.track_id = track_id
        paper.abstract = abstract
        paper.additional_notes = additional_notes
        paper.save!

        speakers.each do |speaker|
          user = find_user(speaker.email, create: true)

          record = OrganizedEventSpeaker.where(paper_id: paper.id, user_id: user.id).first
          record ||= OrganizedEventSpeaker.create!(paper_id: paper.id, user_id: user.id)
          record.tshirt_size_id = speaker.tshirt_size_id
          record.primary = speaker.primary
          record.save!
        end

        OrganizedEventSpeaker.where(id: speaker_ids_to_remove).destroy_all

        taggeds_form.submit
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each do |message|
        errors.add :base, message
      end
      false
    end

    def to_model
      paper
    end

    def find_user email, create: false
      user = UserEmail.where(email: email).first.try(:user)
      if not user and create
        user = User.create!(email: email, password: SecureRandom.hex)
        user.emails.create!(email: email, active: true)

        invitation = TeamInvitation.new code: Digest::MD5.hexdigest(DateTime.now.to_f.to_s + Random.new.rand.to_s),
                                        email: email,
                                        team: paper.team,
                                        user: user,
                                        accepted: nil
        invitation.save

        UserMailer.organized_event_paper_invitaion(invitation, paper).deliver_now
      end
      user
    end

    def speaker_ids_to_remove
      new_speakers = speakers.collect do |speaker|
        user = find_user(speaker.email)
        OrganizedEventSpeaker.where(paper_id: paper.id, user_id: user.id).first
      end.compact
      paper.speakers.pluck(:id) - new_speakers.map(&:id)
    end
  end
end