class AddressSerializer < ActiveModel::Serializer
  attributes :street1, :street2, :city, :state, :country, :postal
end