class FixCitiesMaterializedView < ActiveRecord::Migration[5.1]
  def up
    execute('DROP INDEX index_cities_fulltext_view;')
    execute('DROP MATERIALIZED VIEW cities_fulltext_view;')

    execute <<-SQL
      CREATE MATERIALIZED VIEW cities_fulltext_view AS
        SELECT 
          cities.id AS city_id,
          setweight(to_tsvector('english', coalesce(f_unaccent(city_names.name),'')), 'A')    ||
          setweight(to_tsvector('english', coalesce(f_unaccent(states.name),'')), 'B')  ||
          setweight(to_tsvector('english', coalesce(f_unaccent(countries.name),'')), 'C') AS search_vector
        FROM cities
        INNER JOIN countries ON countries.id = cities.country_id
        LEFT OUTER JOIN states ON states.id = cities.state_id
        INNER JOIN city_names ON city_names.city_id = cities.id
      WITH DATA;
    SQL

    execute <<-SQL
      CREATE INDEX index_cities_fulltext_view ON cities_fulltext_view USING GIN(search_vector);
    SQL
  end

  def down
  end
end
