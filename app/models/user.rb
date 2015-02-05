class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable, :invitable

  validates_presence_of :name

  has_attached_file :avatar,
    :url => "/:class/pictures/:id/:filename",
    :path => "public/:class/pictures/:id/:filename",
    :default_url => "/assets/missing.jpg",
    :storage => :s3,
    :bucket => ENV["BUCKET_NAME"],
    :s3_credentials => S3_CREDENTIALS
  
  validates_attachment :avatar, :presence => true,
    :content_type => { :content_type => ['image/jpeg', 'image/png'] },
    :size => { :less_than => 1.megabytes },
    :if => :avatar?
  has_many :employees
  has_many :establishments, through: :employees
  has_many :enrolled_challenges, foreign_key: 'patron_id'
  has_many :challenges, through: :enrolled_challenges
  has_many :ballyhoos
  has_one :address,as: :resource, dependent: :destroy
  accepts_nested_attributes_for :address
  def to_s
    name
  end

  def employee_for(establishment)
    @current_employee ||= begin
      establishment.employees.find_by(user_id: id)
    end
  end

  def has_establishment_access?
    self.establishment_access
  end
end
