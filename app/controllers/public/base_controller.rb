module Public
  class BaseController < ApplicationController
    skip_before_action :authenticate!, :require_team!
    layout 'public_ui'

    before_action do
      Authorization.activate(nil, nil)
    end
  end
end