class AddFieldsToQuizCategories < ActiveRecord::Migration[7.2]
  def change
    add_column :quiz_categories, :description, :text
    add_column :quiz_categories, :slug, :string
    add_index :quiz_categories, :slug, unique: true
  end
end 