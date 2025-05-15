class CreateUserProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :user_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :username, null: false
      t.timestamps
    end

    add_index :user_profiles, :username, unique: true
  end
end 