class Biography < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :content, presence: true
  validates :user_id, presence: true

  def default?
    user.default_biography_id == id
  end
end
