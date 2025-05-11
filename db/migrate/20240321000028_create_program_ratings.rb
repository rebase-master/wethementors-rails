class CreateProgramRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :program_ratings do |t|
      t.references :program, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.text :review
      t.boolean :verified_completion, default: false
      t.boolean :helpful_votes_count, default: 0
      t.boolean :unhelpful_votes_count, default: 0
      t.boolean :flagged, default: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :program_ratings, [:program_id, :user_id], unique: true
    add_index :program_ratings, :rating
    add_index :program_ratings, :verified_completion
    add_index :program_ratings, :flagged
  end
end 