class UpdateAggregateMetricMetadataModel < ActiveRecord::Migration
  def self.up
    remove_column :aggregate_metric_metadatas, :metric_type
    add_column :aggregate_metric_metadatas, :namespace_id, :integer
  end

  def self.down
    add_column :aggregate_metric_metadatas, :metric_type, :integer
    remove_column :aggregate_metric_metadatas, :namespace_id
  end
end
