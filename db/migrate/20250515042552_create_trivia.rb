class CreateTrivia < ActiveRecord::Migration[7.2]
  def change
    create_table :trivia do |t|
      t.text :fact, null: false
      t.timestamps
    end
  end
end 