class ExpenseType < ApplicationRecord

  has_many  :expenses

  belongs_to  :team

end
