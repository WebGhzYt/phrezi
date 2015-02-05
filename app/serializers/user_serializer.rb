class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_name, :email, :current_check_in

  def current_check_in
    @checkin = Checkin.where(user_id: object.id).first
    unless @checkin.nil?
    	establishment = @checkin.establishment
    {
    	checkin_establishment: establishment.name,
    	checkin_time: @checkin.start_time
    }
    end
  end
end
