class Namespace < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :metrics
  has_many :aggregate_metrics
  
  validates_uniqueness_of :name
  
  def metric_names
    Metric.find(:all, :group => :name, :select => 'DISTINCT name', :conditions => {:namespace_id => self.id}).map { |metric| metric.name }
  end
  
  def aggregate_metric_names
    AggregateMetric.find(:all, :group => :name, :select => 'DISTINCT name', :conditions => {:namespace_id => self.id}).map { |metric| metric.name }
  end
  
  def to_param
    name
  end
end
