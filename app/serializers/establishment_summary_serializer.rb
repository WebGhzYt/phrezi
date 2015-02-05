class EstablishmentSummarySerializer < ActiveModel::Serializer
  attributes :close_time, :current_challenge, :gps_lat, :gps_long, :id, :is_open, :name, :timezone


  def is_open
    object.is_open_now?
  end

  def current_challenge
    object.challenges.each do |challenge|
      if challenge.active?
        @active_challenge =  challenge
      end
    end
    unless @active_challenge.nil?
      participants = @active_challenge.enrolled_challenges
      no_of_participants = participants.count
      payout = @active_challenge.calculate_current_payouts(no_of_participants.to_i)
      all_participants = @active_challenge.enrolled_challenges.sort_by(&:current_points).reverse
      position = all_participants.index(all_participants.find { |a| a.patron_id == current_user.id })
      current_position = position.nil? ? 0 : position + 1
      user = participants.where(patron_id: current_user.id).first
      
      if user.nil?
        current_points = 0
      else
        current_points = user.current_points
      end
      if payout.empty? || position.nil?
        payout = 0
      else
        payout = payout[position].to_f
      end
      {
        start_date: @active_challenge.start_date.strftime('%Y-%m-%d'),
        end_date: @active_challenge.end_date.strftime('%Y-%m-%d'),
        id: @active_challenge.id,
        current_payout: payout,
        total_participants: no_of_participants,
        current_position: current_position,
        current_points: current_points
      }
    end
  end

  def close_time
    establishment = object.establishment_hours.select { |e| e.day == Time.now.strftime("%A").camelize }
    establishment.try(:first).try(:close_time).try(:in_time_zone, object.timezone.to_i).try(:strftime, "%H:%M:%S")
  end
end
