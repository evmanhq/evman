class Attachment < ApplicationRecord

  has_attached_file :file
  do_not_validate_attachment_file_type :file

  belongs_to  :user
  belongs_to  :parent, :polymorphic => true

  validates :name, presence: true

  def concerned_teams
    parent.concerned_teams
  end

  def concerned_users
    (parent.concerned_users + [user]).uniq
  end

  def redirect_path
    h = Rails.application.routes.url_helpers
    case parent
    when Event
      h.attachments_event_path(parent)
    else
      parent
    end
  end


end
