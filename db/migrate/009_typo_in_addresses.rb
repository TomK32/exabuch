class TypoInAddresses < ActiveRecord::Migration
  def self.up
    rename_column :addresses, :owner_by_user, :owned_by_user
  end

  def self.down
    rename_column :addresses, :owned_by_user, :owner_by_user
  end
end
