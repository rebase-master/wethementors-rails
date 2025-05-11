class CreateTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :topics do |t|
      t.string :name, null: false
      t.string :url_name, null: false
      t.boolean :visible, default: true
      t.timestamps
    end

    add_index :topics, :name, unique: true
    add_index :topics, :url_name, unique: true
    add_index :topics, :visible
  end
end 