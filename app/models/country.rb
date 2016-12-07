class Country < ApplicationRecord

  belongs_to :continent
  belongs_to :currency

  has_many :cities
end
