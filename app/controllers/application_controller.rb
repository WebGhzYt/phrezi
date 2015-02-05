class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # protect_from_forgery with: :null_session

  before_filter :configure_permitted_parameters, if: :devise_controller?
  
    rescue_from 'ActionController::RedirectBackError' do
      redirect_to root_path
    end

    rescue_from Pundit::NotAuthorizedError do
      respond_to do |format|
        messages = []
        messages << "You are not authorized to do this action."
        format.js {render "/layouts/errors", locals: { full_errors: messages }}
        format.html {redirect_to root_path}
      end
    end

    def after_sign_out_path_for(resource)
      root_path
    end

    # establishment related methods from web application controller also added here.

    def load_establishment
      redirect_to new_establishment_path(:msg => "true"), notice: 'Please create an establishment to access rest of this site' if current_establishment.blank?
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

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u|
        u.permit(:email, :password, :password_confirmation, :name ,:last_name ,:address_attributes=>[:street1,:street2,:postal,:city,:state,:province])
      }
      devise_parameter_sanitizer.for(:account_update) { |u|
        u.permit(:name, :password, :password_confirmation, :current_password,:last_name,:avatar ,:address_attributes=>[:id,:street1,:street2,:postal,:city,:state,:province,:country])
      }
      devise_parameter_sanitizer.for(:accept_invitation).concat [:name, :last_name]
    end

    private

    def get_current_establishment
      return unless user_signed_in?

      if session[:establishment_id]
        establishment = current_user.establishments.find_by(id: session[:establishment_id])
        return establishment if establishment.present?
      end

      current_user.establishments.first
    end
  end