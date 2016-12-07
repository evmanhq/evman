class FulltextingInPostgres < ActiveRecord::Migration[5.0]
  def up
    execute('CREATE EXTENSION unaccent;')
    execute('CREATE OR REPLACE FUNCTION f_unaccent(text) RETURNS text AS $func$ SELECT public.unaccent(\'public.unaccent\', $1) $func$ LANGUAGE sql IMMUTABLE;')
    execute('CREATE INDEX index_fulltext_cities ON cities USING gin(to_tsvector(\'english\', f_unaccent(display)));')
  end

  def down
    execute('DROP INDEX index_fulltext_cities;')
    execute('DROP FUNCTION f_unaccent(text);')
    execute('DROP EXTENSION unaccent;')
  end
end
