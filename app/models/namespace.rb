class Namespace < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :metrics
  has_many :aggregate_metrics
  
  validates_uniqueness_of :name
  
  def to_param
    name
  end
end
