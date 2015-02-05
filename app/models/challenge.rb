class Challenge < ActiveRecord::Base
  belongs_to :establishment

  has_many :enrolled_challenges
  validates :duration, numericality: { only_integer: true, greater_than: 0}, :if => :duration
  validates :start_date, :end_date, :challenge_prize, :challenge_winner, presence: true
  validate :overlaps?
  before_save :set_win_differential
  
  
  attr_accessor :duration
  WIN_DIFFERENTIAL = '10'

  def set_win_differential
    self.win_differential = WIN_DIFFERENTIAL
  end

  def active?
    challenge_start_date = self.start_date.try(:to_date)
    challenge_end_date = self.end_date.try(:to_date)
    challenge_start_date.nil? ? false : (challenge_start_date == Date.today || (challenge_start_date < Date.today && Date.today <= challenge_end_date))
  end

  def upcoming?
    challenge_start_date = self.start_date.try(:to_date)
    challenge_start_date.nil? ? false : challenge_start_date > Date.today
  end

  #returns an array of payout amounts where the size of the array is the number of tiers
  def calculate_current_payouts(num_participants)
    puts "sales: #{gross_sales} prize: #{challenge_prize} challenge_winner: #{challenge_winner} num_participants: #{num_participants}\n"
    _challengewinners = (challenge_winner/100)*num_participants
    _challengewinners = _challengewinners.ceil
    puts "Number of winners is #{_challengewinners}\n"
    _payouts ||= []
  
    for i in 1.._challengewinners
      _payout = calculate_current_payouts_for_brackettier(i, _challengewinners)
      _payouts << _payout
    end
    return _payouts.reverse
  end

  #returns the payout for a particular tier based on current gross sales.
  def calculate_current_payouts_for_brackettier(bracket_number, tiers)
    puts "Execute #{bracket_number}, #{tiers}\n"
    _numerator = (win_differential/100)+1
    _numerator = _numerator**(bracket_number-1)
    _numerator = _numerator*(challenge_prize/100)*gross_sales

    _denominator = 0
    x = 0
    while x < tiers do
      _denominator += ((win_differential/100)+1)**x
      x = x + 1
    end
    _sum = _numerator / _denominator
    puts "Payout is #{_sum}\n"
    return _sum
  end

  def find_close_time
    challenge = self.establishment.establishment_hours.where(:day => Date.today.strftime("%A").downcase).last
    return challenge.close_time
  end

  def calculate_challenge_cost(active_challenge)
    unless active_challenge.nil?
      payout = active_challenge.payout
      prize = active_challenge.challenge_prize
      total = payout + prize + 2
    end
  end

  def self.create_upcoming_challenges
    challenges = Challenge.all
    unless challenges.nil?
      challenges.each do |challenge|
        challenge_start_date = challenge.start_date.try(:to_date)
        challenge_end_date = challenge.end_date.try(:to_date)
        if challenge.active? && challenge_end_date == Date.today
          upcoming_challenge = Challenge.where(linked_with: challenge.id).first
          if upcoming_challenge.nil?
            difference = (challenge_end_date - challenge_start_date).to_i + 1
            upcoming_challenge = Challenge.new( 
              establishment_id: challenge.establishment_id,
              challenge_winner: challenge.challenge_winner,
              challenge_prize: challenge.challenge_prize,
              win_differential: challenge.win_differential,
              payout: challenge.payout,
              duration: difference,
              repeat: challenge.repeat,
              linked_with: challenge.id,
              start_date: challenge.end_date.strftime("%Y-%m-%d").to_date + 1.day,
              end_date: challenge.end_date.strftime("%Y-%m-%d").to_date + (difference).day
            )
            upcoming_challenge.save
          end
        end
      end
    end
  end

  private
  def overlaps?
    # If start_date or end_date falls between start_date and end_date of any
    # other challenge, then this challenge overlaps with that challenge.
    challenges = self.establishment.challenges
    challenges = challenges.where('id <> :id', id: id) if id.present?

    if challenges.where('start_date >= :sd AND start_date <= :ed OR end_date <= :ed AND end_date >= :sd', sd: start_date, ed: end_date).any?
      errors.add(:start_date, 'cannot overlap with other challenges')
    end
  end



  # def overlaps?
  #   # If start_date or end_date falls between start_date and end_date of any
  #   # other challenge, then this challenge overlaps with that challenge.
  #   active_challenges = self.establishment.challenges.select { |e| e.active? }
  #   Rails.logger.info active_challenges
  #   unless active_challenges.blank?
  #     ed = active_challenges.try(:first).try(:end_date)
  #     if self.start_date <= ed
  #       errors.add(:start_date, "cannot overlap with active challenges") if ed.present?
  #     end
  #   end
  # end
end
