class ExpenseType < ApplicationRecord

  belongs_to  :team
  has_many  :expenses

end
