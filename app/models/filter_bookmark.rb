class FilterBookmark < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  belongs_to :team

  validates :name, presence: true
  validates :code, length: { maximum: 36 }, presence: true, uniqueness: true
  authorize_values_for :owner

  before_validation do |bookmark|
    bookmark.code ||= SecureRandom.uuid
  end

  def filterer_class
    Filterer.const_get(filterer_name.classify) rescue nil
  end

  def filterer
    return nil unless filterer_class
    filterer_class.new(payload: payload, current_team: team)
  end
end
