class ChallengeSerializer < ActiveModel::Serializer
  attributes :start_date, :end_date, :id, :current_payout, :current_position, :participants

  def start_date
    object.start_date.strftime('%Y-%m-%d')
  end

  def end_date
    object.end_date.strftime('%Y-%m-%d')
  end

  def participants
    participants = []
    payout = object.calculate_current_payouts(object.participants.to_i)
    object.enrolled_challenges.sort_by(&:current_points).reverse.each_with_index do |challenge, i|
    participants << {
      id: challenge.patron.try(:id),
      first_name: challenge.try(:patron).try(:name),
      last_name: challenge.try(:patron).try(:last_name),
      points: challenge.try(:current_points),
      payouts: payout[i].to_f,
      ranking: i+1
    }
    end
    participants
  end

  def payout
    payout = object.calculate_current_payouts(object.participants.to_i)
    object.enrolled_challenges.sort_by(&:current_points).reverse.each_with_index do |challenge, i|
      if challenge.patron.try(:id) == current_user["id"]
        @payout = payout[i].to_f
      end
    end
    @payout
  end

  def position
    object.enrolled_challenges.sort_by(&:current_points).reverse.each_with_index do |challenge, i|
      if challenge.patron.try(:id) == current_user["id"]
        @position = i+1
      end
    end
    @position
  end

  def current_payout
    if payout.nil?
      0
    else
      payout
    end
  end

  def current_position
    if position.nil?
      0
    else
      position
    end
  end

end
