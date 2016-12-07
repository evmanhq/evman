class Expense < ApplicationRecord

  belongs_to  :event
  belongs_to  :user
  belongs_to  :expense_type

  validates_presence_of :event, :user, :expense_type

  def name
    expense_type.name
  end

  def cost
    price * (amount || 1)
  end

  def price
    self.usd
  end

end
