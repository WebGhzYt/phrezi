class CategoriesController < WebApplicationController
  def create
    Category.create(:category=>params[:category][:category],:establishment_id=>current_establishment.id)
    respond_to do |format|
      format.js {render "/layouts/flash", :locals=> { :title=> 'Congratulations !!', :message=> 'Category was successfully created.', :redirect_to=> "/challenges?category=true" }}
    end
  end
end