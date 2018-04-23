class Announcement < ApplicationRecord

  has_many :announcement_users
  belongs_to :team

  def self.new_for_user(user)
    Announcement
      .where(team: [nil] + user.teams)
      .where.not(id: AnnouncementUser.select(:announcement_id).where(user: user))
      .order(id: :desc)
  end

end
