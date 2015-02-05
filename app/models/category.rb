class Category < ActiveRecord::Base
  belongs_to :establishment
  def self.all_categories(current_establishment)
    current_establishment.categories.all.collect{|c| c.category}
  end
end
