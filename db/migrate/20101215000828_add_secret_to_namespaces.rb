class AddSecretToNamespaces < ActiveRecord::Migration
  def self.up
    add_column :namespaces, :secret, :string
  end

  def self.down
    remove_column :namespaces, :secret
  end
end
