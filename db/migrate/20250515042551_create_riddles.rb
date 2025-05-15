class CreateRiddles < ActiveRecord::Migration[7.2]
  def change
    create_table :riddles do |t|
      t.text :riddle, null: false
      t.text :answer, null: false
      t.boolean :visible, default: true
      t.timestamps
    end

    add_index :riddles, :visible
  end
end 