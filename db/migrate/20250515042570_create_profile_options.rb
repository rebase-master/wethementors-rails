class CreateProfileOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :profile_options do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_index :profile_options, :name, unique: true
  end
end 