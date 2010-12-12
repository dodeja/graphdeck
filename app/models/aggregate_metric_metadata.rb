class AggregateMetricMetadata < ActiveRecord::Base
  belongs_to :namespace
  
  validates_presence_of :name
  validates_presence_of :timestamp
  validates_presence_of :duration
  validates_presence_of :namespace_id
  
  validates_uniqueness_of :name, :scope => [:duration]
end
