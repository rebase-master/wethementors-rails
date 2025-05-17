class AddConfirmedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :confirmed, :boolean, default: false, null: false
    add_index :users, :confirmed
  end
end 