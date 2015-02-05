class Establishment < ActiveRecord::Base
  acts_as_mappable  :lat_column_name => :gps_lat,
                    :lng_column_name => :gps_long

  belongs_to :address
  belongs_to :group

  has_many :patron_carts
  has_many :employees, -> {order 'employees.role desc'}
  has_many :challenges
  has_many :establishment_hours, -> { order 'id' }
  has_many :menu_items
  has_many :users, through: :employees
  has_many :ballyhoos
  has_many :product_categories
  has_many :products, through: :product_categories
  has_many :establishments_loyal_patrons
  has_many :categories
  has_many :loyal_patrons, through: :establishments_loyal_patrons
  delegate :checkin_ballyhoos, :purchase_ballyhoos, :task_ballyhoos, to: :ballyhoos
  before_save :get_timezone
  # after_save :set_utc_time

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :establishment_hours
  accepts_nested_attributes_for :menu_items
  accepts_nested_attributes_for :employees
  validates_uniqueness_of :name
  validates_presence_of :name, :address,:gps_lat, :gps_long
  reverse_geocoded_by :gps_lat, :gps_long

  has_attached_file :picture,
                    :styles => { 
                    :small => "100x100#",
                    :large => "500x500>",
                    },
                    :processors => [:cropper],
                    :url => "/:class/pictures/:id/:filename",
                    :path => "public/:class/pictures/:id/:filename",
                    :default_url => "/assets/missing.jpg",
                    :storage => :s3,
                    :bucket => ENV["BUCKET_NAME"],
                    :s3_credentials => S3_CREDENTIALS

  
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  
  validates_attachment :picture, :presence => true,
                                :content_type => { :content_type => ['image/jpeg', 'image/png'] },
                                :size => { :less_than => 1.megabytes },
                                :if => :picture?

  def to_s
    name
  end

  def is_open_now?
    false
  end

  def todays_hours
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  
  def avatar_geometry(style = :original)
    @geometry ||= {}
    avatar_path = (picture.options[:storage] == :s3) ? picture.url(style) : picture.path(style)
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar_path)
  end

  def get_timezone
    timezone = Timezone::Zone.new :latlon => [self.gps_lat, self.gps_long]
    offset_in_hours = TZInfo::Timezone.get(timezone.zone).current_period.utc_offset / (60*60)
    self.timezone = offset_in_hours
  end

  def set_utc_time
    self.establishment_hours.each do |estab|
      estab.update_attributes(open_time: estab.try(:open_time).try(:in_time_zone, -self.timezone.to_i).try(:strftime, "%H:%M:%S"))
      estab.update_attributes(close_time: estab.try(:close_time).try(:in_time_zone, -self.timezone.to_i).try(:strftime, "%H:%M:%S"))
    end
  end
end
