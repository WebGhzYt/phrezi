class ProductCategory < ActiveRecord::Base
  has_many :products, dependent: :destroy
  belongs_to :establishment

  validates_presence_of :name, message: "can't be blank"
  validates_presence_of :default_points, message: "can't be blank"
end
