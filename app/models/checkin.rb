class Checkin < ActiveRecord::Base
  belongs_to :establishment
  belongs_to :user
  
  scope :current_checkin, ->(user_id) { where(user_id: user_id, end_time: nil) }
  scope :currently_checkin_user, -> { where( end_time: nil) }

  def self.checkout_all_patrons
    @all_checkins = Checkin.all.where(end_time: nil)
    unless @all_checkins.nil?
      @all_checkins.each do |checkin|
        day = checkin.start_time.strftime("%A").camelize
        if checkin.establishment.establishment_hours.where(day: day).first.closed? == false
          checkin.update_attributes(end_time: Time.now)
          puts "#{checkin.user} checked out."
        end
      end
    end
  end 
end
