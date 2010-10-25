class AggregateMetric < ActiveRecord::Base
  AVERAGE = 1
  TP50 = 2
  TP90 = 3
  TP99 = 4
  TP100 = 5
  
  validates_presence_of :name
  validates_presence_of :value
  validates_presence_of :timestamp
  validates_presence_of :duration
  validates_presence_of :metric_type
  
  validates_numericality_of :value
  
  validates_uniqueness_of :name, :scope => [:timestamp, :duration, :metric_type]
end
