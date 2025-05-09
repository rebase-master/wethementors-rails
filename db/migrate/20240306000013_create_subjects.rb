class CreateSubjects < ActiveRecord::Migration[7.1]
  def change
    create_table :subjects do |t|
      t.string :name, null: false
      t.string :url_name, null: false
      t.boolean :visible, default: true
      t.timestamps
    end

    add_index :subjects, :name, unique: true
    add_index :subjects, :url_name, unique: true
    add_index :subjects, :visible
  end
end 