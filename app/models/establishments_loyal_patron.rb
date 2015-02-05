class EstablishmentsLoyalPatron < ActiveRecord::Base
  belongs_to :establishment
  belongs_to :loyal_patron
end
