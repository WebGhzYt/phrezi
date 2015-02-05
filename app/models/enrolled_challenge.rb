class EnrolledChallenge < ActiveRecord::Base
  belongs_to :challenge
  belongs_to :patron, foreign_key: :patron_id, class_name: 'User'
  
 
  # validates :amount, numericality: { greater_than: 0 }
  # before_save :purchase_points
  
  scope :purchase_history, -> { where(challenge_id: nil) }

  attr_accessor :amount
end
