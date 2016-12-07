class SlackUser < ApplicationRecord

  belongs_to :slack_setting
  belongs_to :user

end
