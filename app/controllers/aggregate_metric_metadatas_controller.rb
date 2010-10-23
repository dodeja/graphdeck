class AggregateMetricMetadatasController < ApplicationController
  # GET /aggregate_metric_metadatas
  # GET /aggregate_metric_metadatas.xml
  def index
    @aggregate_metric_metadatas = AggregateMetricMetadata.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @aggregate_metric_metadatas }
    end
  end

  # GET /aggregate_metric_metadatas/1
  # GET /aggregate_metric_metadatas/1.xml
  def show
    @aggregate_metric_metadata = AggregateMetricMetadata.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @aggregate_metric_metadata }
    end
  end

  # GET /aggregate_metric_metadatas/new
  # GET /aggregate_metric_metadatas/new.xml
  def new
    @aggregate_metric_metadata = AggregateMetricMetadata.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @aggregate_metric_metadata }
    end
  end

  # GET /aggregate_metric_metadatas/1/edit
  def edit
    @aggregate_metric_metadata = AggregateMetricMetadata.find(params[:id])
  end

  # POST /aggregate_metric_metadatas
  # POST /aggregate_metric_metadatas.xml
  def create
    @aggregate_metric_metadata = AggregateMetricMetadata.new(params[:aggregate_metric_metadata])

    respond_to do |format|
      if @aggregate_metric_metadata.save
        format.html { redirect_to(@aggregate_metric_metadata, :notice => 'Aggregate metric metadata was successfully created.') }
        format.xml  { render :xml => @aggregate_metric_metadata, :status => :created, :location => @aggregate_metric_metadata }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @aggregate_metric_metadata.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /aggregate_metric_metadatas/1
  # PUT /aggregate_metric_metadatas/1.xml
  def update
    @aggregate_metric_metadata = AggregateMetricMetadata.find(params[:id])

    respond_to do |format|
      if @aggregate_metric_metadata.update_attributes(params[:aggregate_metric_metadata])
        format.html { redirect_to(@aggregate_metric_metadata, :notice => 'Aggregate metric metadata was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @aggregate_metric_metadata.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /aggregate_metric_metadatas/1
  # DELETE /aggregate_metric_metadatas/1.xml
  def destroy
    @aggregate_metric_metadata = AggregateMetricMetadata.find(params[:id])
    @aggregate_metric_metadata.destroy

    respond_to do |format|
      format.html { redirect_to(aggregate_metric_metadatas_url) }
      format.xml  { head :ok }
    end
  end
end
