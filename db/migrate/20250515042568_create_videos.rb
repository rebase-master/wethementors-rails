class CreateVideos < ActiveRecord::Migration[7.2]
  def change
    create_table :videos do |t|
      t.string :heading, null: false
      t.string :link, null: false
      t.text :description
      t.string :source
      t.timestamps
    end

    add_index :videos, :heading
    add_index :videos, :source
  end
end 