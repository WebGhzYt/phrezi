class PurchaseBallyhoo < Ballyhoo
  validate :valid_purchase_amount
  validates :min_no_of_item, numericality: { only_integer: true, greater_than: 0 }
  validates_presence_of :point_multiplier, :if => :point_multiplier?
  validates_presence_of :point_addition, :if => :point_addition?
  enum purchase_type: [:item, :category]
  

  def valid_purchase_amount
    unless (self.purchase_amount == 'No Minimum') || (self.purchase_amount.match /\d$/)
      errors.add(:purchase_amount, "must be a number or 'No Minimum'")
    end
  end

  
  def process_for(user)
    # steps to process this purchase ballyhoo
  end
end
