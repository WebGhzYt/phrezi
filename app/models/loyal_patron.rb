class LoyalPatron < ActiveRecord::Base
  belongs_to :patron_cart
  has_many :establishments_loyal_patrons
  has_many :establishments, through: :establishments_loyal_patrons
  has_many :purchase_transactions
  
  def self.active_boosters(challenge_id,establishment_id,loyal_patron_id)
    ## find boosters of loyal_patron with active challenges and current-establishments
    puts 'xxxxxxxxxxxxxxxxxxxx',challenge_id.inspect
    BoosterTransaction.where(:loyal_patron_id=>loyal_patron_id,:establishment_id=>establishment_id,:challenge_id=>challenge_id).count
  end
  
  def self.loyal_patrons_boosters(establishment_id,loyal_patron_id)
    ## find all boosters of loyal_patron with active challenges and current-establishments
    BoosterTransaction.where(:loyal_patron_id=>loyal_patron_id,:establishment_id=>establishment_id).count
  end
  
  def self.points(challenge_id,loyal_patron_id)
    challenge = Challenge.find(challenge_id)
    purchase_transaction = PurchaseTransaction.find_by_loyal_patron_id(loyal_patron_id)
    return (purchase_transaction.amount.to_i * (challenge.payout/100))
  end
end
