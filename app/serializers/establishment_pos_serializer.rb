class EstablishmentPosSerializer < ActiveModel::Serializer
  attributes :name, :phone, :gps_lat, :gps_long, :id, :website, :picture
  has_one :address
end