class PurchaseTransaction < ActiveRecord::Base
  belongs_to :loyal_patron
  has_many :booster_transactions
end
