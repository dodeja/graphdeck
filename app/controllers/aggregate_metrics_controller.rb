class AggregateMetricsController < ApplicationController
  
  before_filter :require_user, :except => [:api]
  before_filter :find_namespace, :except => [:api]
  
  def view
    @type = 0
    @type = params[:type].to_i unless params[:type].nil?
    
    @duration = 300
    @duration = params[:duration].to_i unless params[:duration].nil?
    
    @window = 86400
    @window = params[:window].to_i unless params[:window].nil?
    
    @from = (Time.now.to_i - @window) / @duration * @duration
    @from = params[:from].to_i unless params[:from].nil?
    
    @to = Time.now.to_i / @duration * @duration
    @to = params[:to].to_i unless params[:to].nil?
    
    @name = params[:name]
    
    @aggregate_metrics = AggregateMetric.find_all_by_name(params[:name], :conditions => ['namespace_id = ? and metric_type = ? and timestamp >= ? and timestamp <= ? and duration = ?', @namespace.id, @type, @from, @to, @duration])
    @indexed_aggregate_metrics = @aggregate_metrics.index_by(&:timestamp)
    
    #AggregateMetric.view_api(:namespace => params[:namespace_id], :name => @name, :type => @type, :duration => @duration, :window => @window, :from => @from, :to => @to)
    
    respond_to do |format|
      format.html # view.html.erb
    end
  end
  
  def api
    if params[:signature].nil?
      success = authenticate_or_request_with_http_basic do |namespace,secret|
        @namespace = Namespace.find_by_name(namespace, :conditions => {:secret => secret})
        !@namespace.nil?
      end
    else
      p = params.dup
      p.delete(:signature)
      p.delete(:action)
      p.delete(:controller)
      p.delete(:callback)
      
      @namespace = Namespace.find_by_name(params[:namespace])
      
      s = ""
      p.keys.sort.each do |key|
        s << key << ',' << p[key].to_s << ','
      end
      s << @namespace.secret
      signature = Digest::MD5.hexdigest(s)
      
      success = signature == params[:signature]
      
      render :status => :unauthorized unless success
    end
    
    if success == true
      callback = params[:callback]
      jsonp = AggregateMetric.jsonp_api(:namespace => @namespace.name, :name => params[:name], :type => params[:type], :from => params[:from], :to => params[:to], :duration => params[:duration])
      response = "#{callback}(#{jsonp.to_json});"
      render :content_type => :js, :text => response
    end    
  end
  
  # GET /aggregate_metrics
  # GET /aggregate_metrics.xml
  def index
    @aggregate_metrics = AggregateMetric.find(:all, :group => :name, :select => 'DISTINCT name', :conditions => {:namespace_id => @namespace.id})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aggregate_metrics }
    end
  end

  # GET /aggregate_metrics/1
  # GET /aggregate_metrics/1.xml
  def show
    @aggregate_metric = AggregateMetric.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aggregate_metric }
    end
  end

  # GET /aggregate_metrics/1/edit
  def edit
    @aggregate_metric = AggregateMetric.find(params[:id])
  end

  # POST /aggregate_metrics
  # POST /aggregate_metrics.xml
  def create
    @aggregate_metric = AggregateMetric.new(params[:aggregate_metric])

    respond_to do |format|
      if @aggregate_metric.save
        format.html { redirect_to(@aggregate_metric, :notice => 'Aggregate metric was successfully created.') }
        format.xml  { render :xml => @aggregate_metric, :status => :created, :location => @aggregate_metric }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aggregate_metric.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aggregate_metrics/1
  # PUT /aggregate_metrics/1.xml
  def update
    @aggregate_metric = AggregateMetric.find(params[:id])

    respond_to do |format|
      if @aggregate_metric.update_attributes(params[:aggregate_metric])
        format.html { redirect_to(@aggregate_metric, :notice => 'Aggregate metric was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aggregate_metric.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aggregate_metrics/1
  # DELETE /aggregate_metrics/1.xml
  def destroy
    @aggregate_metric = AggregateMetric.find(params[:id])
    @aggregate_metric.destroy

    respond_to do |format|
      format.html { redirect_to(aggregate_metrics_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_namespace
    @namespace = Namespace.find_by_name(params[:namespace_id])
  end
  
end
