class BallyhooDay < ActiveRecord::Base
  belongs_to :ballyhoo
  validates_presence_of :end_repeat, :repeat_type, :day
end