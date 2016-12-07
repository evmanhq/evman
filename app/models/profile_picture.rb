class ProfilePicture < ApplicationRecord
  has_attached_file :image,
                    styles: {
                        medium: "300x300>",
                        thumb: "100x100#" }

  validates_attachment_content_type :image, content_type: /\Aimage/

  belongs_to :user

  def default?
    user.default_profile_picture_id == id
  end

end
