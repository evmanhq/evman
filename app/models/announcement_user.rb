class AnnouncementUser < ApplicationRecord

  belongs_to :announcement, inverse_of: :announcement_users
  belongs_to :user, inverse_of: :announcement_users

end
