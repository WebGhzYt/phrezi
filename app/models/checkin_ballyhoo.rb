class CheckinBallyhoo < Ballyhoo
 
  validates_presence_of :point_value, numericality: { only_integer: true, greater_than: 0 }
  
  def process_for(user)
    # steps to process this checkin ballyhoo
  end
end
