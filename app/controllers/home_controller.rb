class HomeController < WebApplicationController
  skip_before_action :load_establishment
  def index
  end
end
