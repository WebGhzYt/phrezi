class Address < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  # validates_uniqueness_of :scope => [:city, :country]
  validates_presence_of :city, :country, :street1
  validates_presence_of :state, :if => :is_state?

  def to_s
    [street1, street2, city, province, country].reject(&:blank?).join(', ')
  end
 
  def is_state?
    attributes["country"] == "United States"
  end
end
