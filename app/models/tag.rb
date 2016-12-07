class Tag < ApplicationRecord

  has_many :taggeds, dependent: :destroy
  belongs_to :team

  validates :name, presence: true

  before_validation :set_keyword

  def set_keyword
    self.keyword = name.downcase
  end

end
