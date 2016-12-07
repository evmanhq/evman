class Tagged < ApplicationRecord

  belongs_to  :item, :polymorphic => true
  belongs_to  :tag

end
