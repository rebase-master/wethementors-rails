class CreateProfileOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :profile_options do |t|
      t.string :name, null: false
      t.string :options, null: false
      t.text :description
      t.boolean :required, default: false
      t.boolean :public, default: true

      t.timestamps
    end

    add_index :profile_options, :name, unique: true
    add_index :profile_options, :options, unique: true
  end
end 