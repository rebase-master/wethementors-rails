class CreateQuizCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_categories do |t|
      t.string :category, null: false
      t.text :description
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :quiz_categories, :category, unique: true
    add_index :quiz_categories, :active
  end
end 