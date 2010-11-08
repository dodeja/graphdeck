class AddMetricsIndexes < ActiveRecord::Migration
  def self.up
    add_index :metrics, :namespace_id, :name => 'namespace_id_ix'
    add_index :metrics, [:name, :namespace_id], :name => 'name_namespace_id_ix'
    add_index :aggregate_metrics, :namespace_id, :name => 'namespace_id_ix'
  end

  def self.down
    remove_index :metrics, 'namespace_id_ix'
    remove_index :metrics, 'name_namespace_id_ix'
    remove_index :aggregate_metrics, 'namespace_id_ix'
  end
end
