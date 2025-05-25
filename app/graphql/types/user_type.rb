class Types::UserType < Types::BaseObject
  field :id, Integer, null: false
  field :name, String, null: true
  field :email, String, null: false
  field :job_title, String, null: true
  field :organization, String, null: true
  field :phone, String, null: true
  field :twitter, String, null: true
  field :github, String, null: true
  field :teams, [Types::TeamType], null: false, preload: :teams
  field :talks, [Types::TalkType], null: false, preload: { talks: :team }
  field :event_talks, [Types::EventTalkType], null: false, preload: :event_talks
  field :events, [Types::EventType], null: false, preload: { events: :teams }
  field :avatar_url, String, null: true, preload: :default_profile_picture
end
