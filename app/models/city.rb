class City < ApplicationRecord

  belongs_to  :country
  belongs_to  :state

  belongs_to  :time_zone
  has_many :city_names
  has_one :english_city_name, -> { joins(:language).where(languages: { code: 'en' }) }, class_name: 'CityName'

  def name
    english_city_name.name
  end

  def to_s
    if country.name == 'United States'
      "#{name}, #{state.name}, #{country.name}"
    else
      "#{name}, #{country.name}"
    end
  end

end
