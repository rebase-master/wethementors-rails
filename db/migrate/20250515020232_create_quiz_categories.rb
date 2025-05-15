class CreateQuizCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_categories do |t|
      t.string :category

      t.timestamps
    end
  end
end
