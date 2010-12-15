class AggregateMetric < ActiveRecord::Base
  COUNT = 0
  AVERAGE = 1
  TP50 = 2
  TP90 = 3
  TP99 = 4
  TP100 = 5
  
  belongs_to :namespace
  
  validates_presence_of :name
  validates_presence_of :value
  validates_presence_of :timestamp
  validates_presence_of :duration
  validates_presence_of :metric_type
  validates_presence_of :namespace_id
  
  validates_numericality_of :value
  
  validates_uniqueness_of :name, :scope => [:timestamp, :duration, :metric_type]
  
  def self.metric_types
    COUNT..TP100
  end
  
  #  AggregateMetric.view_api(:namespace => params[:namespace_id], :name => @name, :type => @type, :from => @from, :to => @to, :duration => @duration)
  def self.jsonp_api(args)
    result = {}
    result[:name] = name = args[:name]
    result[:namespace] = namespace = args[:namespace]
    result[:type] = type = args[:type].to_i
    result[:from] = from = args[:from].to_i
    result[:to] = to = args[:to].to_i
    result[:duration] = duration = args[:duration].to_i
    
    if name.nil? or namespace.nil? or type.nil? or from.nil? or to.nil? or duration.nil?
      return result
    end
    
    result[:tsd] = []

    namespace_id = Namespace.find_by_name(namespace).id
    metrics = self.find_all_by_name(name, :conditions => ['namespace_id = ? and metric_type = ? and timestamp >= ? and timestamp <= ? and duration = ?', namespace_id, type, from, to, duration])
    metrics.each do |metric,index|
      result[:tsd] << {:timestamp => metric.timestamp.to_i, :value => metric.value}
    end
    
    result
  end
  
end
