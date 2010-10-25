class CreateAggregateMetricMetadatas < ActiveRecord::Migration
  def self.up
    create_table :aggregate_metric_metadatas do |t|
      t.string :name
      t.integer :timestamp
      t.integer :duration
      t.integer :metric_type

      t.timestamps
    end
  end

  def self.down
    drop_table :aggregate_metric_metadatas
  end
end
