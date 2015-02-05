class WebApplicationController < ApplicationController
  before_filter :load_establishment, unless: :devise_controller?

  def load_establishment
    if current_user.has_establishment_access?
      redirect_to new_establishment_path, notice: 'Please create an establishment to access rest of this site' if Establishment.all.blank?
    else
      redirect_to new_establishment_path, notice: 'Please create an establishment to access rest of this site' if current_establishment.blank?
    end
  end

  def establishment_loaded?
    current_establishment.present?
  end
  helper_method :establishment_loaded?

  def current_employee
    current_user.employee_for(current_establishment)
  end
  helper_method :current_employee

  def current_establishment
    @current_establishment ||= get_current_establishment
  end
  helper_method :current_establishment

  def current_establishment=(establishment)
    session[:establishment_id] = establishment.id
    @current_establishment = establishment
  end

  def pundit_user
    current_employee
  end

  def get_current_establishment
    return unless user_signed_in?

    if session[:establishment_id]
      if current_user.has_establishment_access?
        establishment = Establishment.find(session[:establishment_id])
      else
        establishment = current_user.establishments.find_by(id: session[:establishment_id])
      end
      return establishment if establishment.present?
    end
    if current_user.has_establishment_access?
      Establishment.first
    else
      current_user.establishments.first
    end
  end
end
