class SlackSetting < ApplicationRecord

  belongs_to :team

  has_many  :slack_users

  def concerned_users
    slack_users.inject([]) { |c, su| c + su.concerned_users }
  end

end
