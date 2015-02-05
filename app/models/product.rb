class Product < ActiveRecord::Base
  belongs_to :product_category
  has_one :establishment, through: :product_category

  validates_presence_of :name
  validates_presence_of :product_category_id, message: ""
end
