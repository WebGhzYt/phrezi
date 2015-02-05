class CartBooster < ActiveRecord::Base
	belongs_to :patron_cart
	belongs_to :boosters, class_name: "Ballyhoo", foreign_key: "booster_id"
end
