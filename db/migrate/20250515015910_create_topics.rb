class CreateTopics < ActiveRecord::Migration[7.2]
  def change
    create_table :topics do |t|
      t.string :topic, null: false
      t.string :url_name, null: false
      t.boolean :visible, default: true

      t.timestamps
    end
    add_index :topics, :url_name, unique: true
  end
end
