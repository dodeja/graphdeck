class AddNamespaceToMetrics < ActiveRecord::Migration
  def self.up
    add_column :metrics, :namespace_id, :integer
    add_column :aggregate_metrics, :namespace_id, :integer
  end

  def self.down
    remove_column :metrics, :namespace_id
    remove_column :aggregate_metrics, :namespace_id
  end
end
