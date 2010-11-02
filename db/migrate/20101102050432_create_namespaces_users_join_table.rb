class CreateNamespacesUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :namespaces_users, :id => false do |t|
      t.integer :namespace_id
      t.integer :user_id
      t.integer :authorizer_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :namespaces_users
  end
end
