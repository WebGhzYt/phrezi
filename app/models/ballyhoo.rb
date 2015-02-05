class Ballyhoo < ActiveRecord::Base
  belongs_to :establishment
  belongs_to :user
  has_many :cart_boosters, foreign_key: "booster_id"
  has_one :ballyhoo_day
  self.inheritance_column = :ballyhoo_type

  validates :ballyhoo_type, presence: true
  
  validates_presence_of :title,:start_date #, :description, unless: "method=='Manual'"
  # validates :friends, numericality: { only_integer: true, greater_than: 0 }, if: "audience=='1'"

  validates :friends, numericality: { only_integer: true}, if: "ballyhoo_type == 'CheckinBallyhoo'"
  validates :total_checkin_qty, numericality: { only_integer: true }, :allow_blank => true, if: "total_checkin_qty != 'Unlimited'"
  validate :is_establishment_open_that_day?
  validate :is_establishment_open_that_open_time? , :if => :start_and_end_time_present?
  validate :is_establishment_open_that_close_time?, :if => :start_and_end_time_present?
  before_save :set_time
  
  scope :checkin_ballyhoos, -> { where(ballyhoo_type: 'CheckinBallyhoo') }
  scope :purchase_ballyhoos, -> { where(ballyhoo_type: 'PurchaseBallyhoo') }
  scope :task_ballyhoos, -> { where(ballyhoo_type: 'TaskBallyhoo') }

  validates :point_value, numericality: { only_integer: true, greater_than: 0}, if: "ballyhoo_type != 'PurchaseBallyhoo'"

  enum repeat_types: [:no_repeat, :daily, :weekly, :monthly]
  # attr_accessor :audience
  # enum audience: ['0', '1']
  attr_accessor :ballyhoo_all_day
  serialize :repeating_days

    def process_for(user)
      raise 'Abstract Method'
    end

    def is_establishment_open_that_day?
      day = attributes["start_date"].to_date.strftime("%A")
      if self.establishment.establishment_hours.where(:day=>day).first.closed == true
        errors.add(:start_date, "Establishment is close on #{attributes["start_date"]}")
      end
    end
  
    def start_and_end_time_present?
      if attributes["start_time"].present? and attributes["end_time"].present?
        return true
      end
    end

    def is_establishment_open_that_open_time?
      days = []
      self.establishment.establishment_hours.each do |hour|
        if !attributes["start_time"].blank? && !hour.open_time.blank?
          if attributes["start_time"].strftime("%H:%M") < hour.open_time.in_time_zone(self.establishment.timezone.to_i).strftime("%H:%M")
            days << hour.day
          end
        end
      end
      if days.present?
        errors.add(:start_time, "Establishment is closed on #{attributes["start_time"].strftime("%I:%M%p")} on #{days}")
      end
    end
    
    def is_establishment_open_that_close_time?
      days = []
      self.establishment.establishment_hours.each do |hour|
        if !attributes["end_time"].blank? && !hour.close_time.blank?
          if attributes["end_time"].strftime("%H:%M") > hour.close_time.in_time_zone(self.establishment.timezone.to_i).strftime("%H:%M")
            days << hour.day
          end
        end
      end
      if days.present?
        errors.add(:end_time, "Establishment is closed on #{attributes["end_time"].strftime("%I:%M%p")} on #{days}")
      end
    end

    def duration
      #this should figure out how many hours / minutes it runs or 'all day'
      'All day'
    end

    def active?
      if self.paused?
        false
      else
        ballyhoo_start_date = self.start_date.try(:to_date)
        ballyhoo_end_repeat = self.end_repeat.try(:to_date)
        ballyhoo_start_time = self.start_time.try(:strftime, "%H:%M")
        ballyhoo_end_time =  self.end_time.try(:strftime, "%H:%M")
        
        repeat_type = self.repeat_type
        repeating_days = self.try(:repeating_days)
        all_day = self.all_day

        
        if all_day == false
          if (ballyhoo_start_time.nil? || ballyhoo_end_time.nil?)
            duration = false
          else
            duration = (ballyhoo_start_time <= Time.zone.now.strftime("%H:%M") && Time.zone.now.strftime("%H:%M") <= ballyhoo_end_time)
          end
        else
          establishment = self.establishment.establishment_hours.select { |e| e.day == Time.now.strftime("%A").camelize }
          open_time = establishment.first.try(:open_time).try(:strftime, "%H:%M")
          close_time = establishment.first.try(:close_time).try(:strftime, "%H:%M")
          unless (open_time.nil? || close_time.nil?)
            if(close_time < open_time)
              close_time = (establishment.first.try(:close_time) + 12.hours).try(:strftime, "%H:%M")
            end
          end
          if establishment.first.try(:closed) == true
            duration = false
          else
            unless ballyhoo_start_date > Date.today
              duration = (open_time <= Time.zone.now.strftime("%H:%M") && Time.zone.now.strftime("%H:%M") <= close_time)
            end 
          end
        end
        
        if ballyhoo_start_date.nil?
          false
        else
          if repeat_type == 1
            if ballyhoo_end_repeat.nil? && repeating_days == ""
              duration
            elsif ballyhoo_end_repeat.nil? && !repeating_days.nil?
              days = repeating_days.split(',')
              todays_day = Time.zone.now.strftime("%A").downcase
              if days.include?(todays_day)
                duration
              else
                false
              end
            elsif !ballyhoo_end_repeat.nil? && repeating_days == ""
              (ballyhoo_start_date <= Date.today && Date.today <= ballyhoo_end_repeat) && duration
            elsif !ballyhoo_end_repeat.nil? && !repeating_days.nil?
              days = repeating_days.split(',')
              todays_day = Time.zone.now.strftime("%A").downcase
              
              if days.include?(todays_day)
                (ballyhoo_start_date <= Date.today && Date.today <= ballyhoo_end_repeat) && duration
              else
                false
              end
            else
              ballyhoo_start_date == Date.today && duration
            end
          else
            ballyhoo_start_date == Date.today && duration 
          end
        end
      end
    end

    def upcoming?
      if self.paused?
        false
      else
        ballyhoo_start_date = self.start_date.try(:to_date)
        ballyhoo_end_repeat = self.end_repeat.try(:to_date)
        ballyhoo_start_time = self.start_time.try(:strftime, "%H:%M")
        ballyhoo_end_time =  self.end_time.try(:strftime, "%H:%M")
        repeat_type = self.repeat_type
        repeating_days = self.try(:repeating_days)
        all_day = self.all_day
        
        if all_day == false
          if (ballyhoo_start_time.nil? || ballyhoo_end_time.nil?)
            duration = false
          else
            if ballyhoo_start_date > Date.today
              duration = true
            else
              duration = (ballyhoo_start_time > Time.zone.now.strftime("%H:%M"))
            end
          end
        else
          establishment = self.establishment.establishment_hours.select { |e| e.day == Time.now.strftime("%A").camelize }
          open_time = establishment.first.try(:open_time).try(:strftime, "%H:%M")
          close_time = establishment.first.try(:close_time).try(:strftime, "%H:%M")
          unless (open_time.nil? || close_time.nil?) 
            if(close_time < open_time)
              close_time = (establishment.first.try(:close_time) + 12.hours).try(:strftime, "%H:%M")
            end
          end
          if establishment.first.try(:closed) == true
            duration = true
          else
            duration = (open_time < Time.zone.now.strftime("%H:%M") && close_time < Time.zone.now.strftime("%H:%M")) || (open_time > Time.zone.now.strftime("%H:%M") && close_time > Time.zone.now.strftime("%H:%M"))
          end
        end
        
        if ballyhoo_start_date.nil?
          false
        else
          if repeat_type == 1
            if ballyhoo_end_repeat.nil? && repeating_days == ""
              true
            elsif ballyhoo_end_repeat.nil? && !repeating_days.nil?
              true
            elsif !ballyhoo_end_repeat.nil? && repeating_days == ""
              (ballyhoo_end_repeat >= Date.today) && true
            elsif !ballyhoo_end_repeat.nil? && !repeating_days.nil?
              days = repeating_days.split(',')
              todays_day = Time.zone.now.strftime("%A").downcase
              if days.include?(todays_day)
                (ballyhoo_end_repeat >= Date.today) && true
              else
                ballyhoo_end_repeat > Date.today
              end
            else
              ballyhoo_start_date > Date.today
            end
          else
            if ballyhoo_start_date > Date.today
              true
            else
              if ballyhoo_start_date >= Date.today
                duration
              end
            end
          end
        end
      end
    end

    def archived?
      if self.paused?
        false
      else
        ballyhoo_start_date = self.start_date.try(:to_date)
        ballyhoo_end_repeat = self.end_repeat.try(:to_date)
        repeat_type = self.repeat_type
        if repeat_type == 0
          ballyhoo_start_date.nil? ? false : ballyhoo_start_date < Date.today
        else
          if ballyhoo_end_repeat.nil?
            if ballyhoo_start_date.nil?
              false
            else
              ballyhoo_start_date < Date.today
            end
          else
            ballyhoo_end_repeat < Date.today
          end
        end
      end
    end

    def paused?
      !self.enabled
    end

    def ballyhoo_type_small
      if self.ballyhoo_type == 'CheckinBallyhoo'
        'Check In'
      elsif self.ballyhoo_type == 'PurchaseBallyhoo'
        'Purchase'
      elsif self.ballyhoo_type == 'TaskBallyhoo'
        'Task'
      else
        'Ballyhoo'
      end
    end

    def for_quantity_available
      unless (self.total_checkin_qty == 'Unlimited') || (self.total_checkin_qty.match /\d$/)
        errors.add(:total_checkin_qty, "should be a number") #if total_checkin_qty.present?
      end
    end

    def ballyhoo_types
      %w(checkin_ballyhoo purchase_ballyhoo task_ballyhoo)
    end

    def self.collect_products(current_establishment)
      menu_items = current_establishment.menu_items.all.collect{|m| [m.name, m.id] }
      # products = current_establishment.products.all.collect{|p| p.name}
      # products + menu_items
    end

    def self.collect_categoies(current_establishment)
      categories = current_establishment.categories.all.collect{|c| [c.category, c.id] }
    end

    def set_time
      # timezone = Timezone::Zone.new :latlon => [self.establishment.gps_lat, self.establishment.gps_long]
      # offset_in_hours = TZInfo::Timezone.get(timezone.zone).current_period.utc_offset / (60*60)
      self.start_time = self.start_time.try(:in_time_zone, -self.establishment.timezone.to_i).try(:strftime, "%H:%M:%S")
      self.end_time = self.end_time.try(:in_time_zone, -self.establishment.timezone.to_i).try(:strftime, "%H:%M:%S")
    end

    class << self
      def audience_types
        ['All Patrons', 'Checked In', 'Not Checked In']
      end

      def recurring_types
        ['No Repeat', 'Daily', 'Weekly', 'Monthly']
      end

      def limit_types
        ['Only once', '1 per day', '1 per week', '1 per month', 'Unlimited']
      end

      def multiplier_types
        ['double', 'triple']
      end
    end

    def as_json(options = {})
      # for calendar
      if options[:calendar].present?
        {
          title: self.title,
          start: self.start_time.nil? ? "#{self.start_date.strftime("%Y-%m-%d")}" : "#{self.start_date.strftime("%Y-%m-%d")}T#{self.start_time.in_time_zone(self.establishment.timezone.to_i).strftime("%H:%M")}"
        }
      else
        # default
        super
      end
    end
  end