class TeamMembership < ApplicationRecord

  belongs_to  :user
  belongs_to  :team
  belongs_to  :team_membership_type

end
