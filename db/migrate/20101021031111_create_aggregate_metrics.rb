class CreateAggregateMetrics < ActiveRecord::Migration
  def self.up
    create_table :aggregate_metrics do |t|
      t.string :name
      t.float :value
      t.integer :timestamp
      t.integer :duration
      t.integer :metric_type

      t.timestamps
    end
  end

  def self.down
    drop_table :aggregate_metrics
  end
end
