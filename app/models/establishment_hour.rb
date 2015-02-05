class EstablishmentHour < ActiveRecord::Base
  belongs_to :establishment


  def closed?
    if self.closed
      false
    else
      establishment_start_time = self.open_time.try(:strftime, "%H:%M")
      establishment_end_time =  self.close_time.try(:strftime, "%H:%M")
      if(establishment_end_time < establishment_start_time)
        establishment_start_time = (self.open_time + 12.hours).try(:strftime, "%H:%M")
        establishment_end_time = (self.close_time + 12.hours).try(:strftime, "%H:%M")
        (establishment_start_time < (Time.zone.now + 12.hours).strftime("%H:%M")) && ((Time.zone.now + 12.hours).strftime("%H:%M") <  establishment_end_time)
      else
        establishment_start_time < Time.zone.now.strftime("%H:%M") && Time.zone.now.strftime("%H:%M") <  establishment_end_time
      end
    end
  end
end
