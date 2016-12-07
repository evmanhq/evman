class ApplicationRecord < ActiveRecord::Base
  include Authorization::ModelHelpers
  self.abstract_class = true
end
