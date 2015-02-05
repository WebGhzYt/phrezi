class BoosterTransaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge
  belongs_to :purchase_transaction
end
