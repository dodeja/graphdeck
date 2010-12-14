class AddIndexAggregateMetrics < ActiveRecord::Migration
  def self.up
    add_index :aggregate_metrics, [:name, :namespace_id, :timestamp, :duration, :metric_type], :name => 'name_namespace_id_timestamp_duration_metric_type_ix'
  end

  def self.down
    remove_index :aggregate_metrics, 'name_namespace_id_timestamp_duration_metric_type_ix'
  end
end
