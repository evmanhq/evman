class SlackSetting < ApplicationRecord

  belongs_to :team

  has_many  :slack_users

end
