require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module Evman
  class Application < Rails::Application

    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths += %W(#{config.root}/app #{config.root}/app/policies)

    config.i18n.load_path += Dir[Rails.root.join('config','locales','**','*.{rb,yml}').to_s]
  end
end
