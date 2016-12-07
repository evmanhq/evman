class City < ApplicationRecord

  belongs_to  :country
  belongs_to  :state

  belongs_to  :time_zone
  has_many :city_names

  def name
    CityName.where(:city => id, :language => Language.find_by_code('en')).first.name
  end

  def to_s
    if country.name == 'United States'
      "#{name}, #{state.name}, #{country.name}"
    else
      "#{name}, #{country.name}"
    end
  end

end
