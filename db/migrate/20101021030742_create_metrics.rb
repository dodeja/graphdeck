class CreateMetrics < ActiveRecord::Migration
  def self.up
    create_table :metrics do |t|
      t.string :key
      t.float :value
      t.integer :timestamp

      t.timestamps
    end
  end

  def self.down
    drop_table :metrics
  end
end
