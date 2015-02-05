class MenuItem < ActiveRecord::Base
  belongs_to :establishment

  class << self
    def item_categories
      ['Starters', 'Draught Beer']
    end
  end
end
