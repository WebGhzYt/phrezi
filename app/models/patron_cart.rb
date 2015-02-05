class PatronCart < ActiveRecord::Base
  has_many :loyal_patrons
  has_many :cart_boosters
  belongs_to :establishment

  def self.remove_carts
    patron_carts = PatronCart.all
    unless patron_carts.nil?
      patron_carts.each do |cart|
        if cart.establishment.establishment_hours.where(day: Time.now.strftime("%A").camelize).first.closed? == false
          cart.destroy
        end
      end
    end
  end
end
