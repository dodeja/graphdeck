class Metric < ActiveRecord::Base
  belongs_to :namespace
  
  validates_presence_of :name
  validates_presence_of :value
  validates_presence_of :timestamp
  validates_presence_of :namespace_id
  
  validates_numericality_of :value
end
