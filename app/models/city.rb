class City < ApplicationRecord

  belongs_to  :country
  belongs_to  :state

  belongs_to  :time_zone
  has_many :city_names
  has_one :english_city_name, -> { joins(:language).where(languages: { code: 'en' }) }, class_name: 'CityName'

  scope :fulltext_search, -> (query) do
    terms = query.to_s.split(' ').map { |item| item  + ':*' }.join('&')
    rank_order = sanitize_sql_for_order([<<-SQL, terms])
      ts_rank(cities_fulltext_view.search_vector, to_tsquery(unaccent(?))) DESC
    SQL
    joins('INNER JOIN cities_fulltext_view ON cities_fulltext_view.city_id = cities.id')
        .where('cities_fulltext_view.search_vector @@ to_tsquery(unaccent(?))', terms)
        .order(rank_order)
  end

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
