class CreateAggregateMetrics < ActiveRecord::Migration
  def self.up
    create_table :aggregate_metrics do |t|
      t.string :key
      t.float :value
      t.integer :timestamp
      t.integer :duration
      t.integer :type

      t.timestamps
    end
  end

  def self.down
    drop_table :aggregate_metrics
  end
end
