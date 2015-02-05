class InfoController < WebApplicationController
  skip_before_action :load_establishment
  
  def about
  end

  def terms
  end
end
