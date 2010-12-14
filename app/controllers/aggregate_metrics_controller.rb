class AggregateMetricsController < ApplicationController
  
  before_filter :require_user
  before_filter :find_namespace
  
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
    
    @aggregate_metrics = AggregateMetric.find_all_by_name(params[:name], :conditions => ['namespace_id = ? and metric_type = ? and timestamp >= ? and timestamp <= ? and duration = ?', @namespace.id, @type, @from, @to, @duration])
    @indexed_aggregate_metrics = @aggregate_metrics.index_by(&:timestamp)
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
