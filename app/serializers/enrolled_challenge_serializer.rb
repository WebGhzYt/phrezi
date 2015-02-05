class EnrolledChallengeSerializer < ActiveModel::Serializer
  attributes :id, :current_points, :establishment_name
  has_one :challenge

  def establishment_name
    "#{object.challenge.establishment.name}"
  end
end
