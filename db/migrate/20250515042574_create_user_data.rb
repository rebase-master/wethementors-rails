class CreateUserData < ActiveRecord::Migration[7.2]
  def change
    create_table :user_data do |t|
      t.references :user, null: false, foreign_key: true
      t.references :profile_option, null: false, foreign_key: true
      t.text :data
      t.timestamps
    end

    add_index :user_data, [:user_id, :profile_option_id], unique: true
  end
end 