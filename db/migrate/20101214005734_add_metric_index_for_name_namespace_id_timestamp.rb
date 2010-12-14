class AddMetricIndexForNameNamespaceIdTimestamp < ActiveRecord::Migration
  def self.up
    add_index :metrics, [:name, :namespace_id, :timestamp], :name => 'name_namespace_id_timestamp_ix'
  end

  def self.down
    remove_index :metrics, 'name_namespace_id_timestamp_ix'
  end
end
