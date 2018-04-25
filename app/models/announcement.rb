class Announcement < ApplicationRecord

  has_many :announcement_users, inverse_of: :announcement, dependent: :destroy
  belongs_to :team

  scope :new_for_user, -> (user) {
    Announcement
        .where(team: [nil] + user.teams)
        .where.not(id: AnnouncementUser.select(:announcement_id).where(user: user))
        .order(id: :desc)
  }

end
