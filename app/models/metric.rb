class Metric < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :value
  validates_presence_of :timestamp
  
  validates_numericality_of :value
end
