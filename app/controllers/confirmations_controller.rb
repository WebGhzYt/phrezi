class ConfirmationsController < Devise::ConfirmationsController
  private

  # when user confirm his email he will logged in and redirect to the user dashboard.
  
  def after_confirmation_path_for(resource_name, resource)
    # flash[:notice] = "Your account was successfully confirmed."
    session[:confirmed] = true
    if request.env["HTTP_USER_AGENT"][/iPhone/]
    	'phrenzi://'
    else
    	'/'
    end
  end
end
