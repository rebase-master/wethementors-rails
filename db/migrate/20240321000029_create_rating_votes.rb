class CreateRatingVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :rating_votes do |t|
      t.references :program_rating, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :helpful, null: false
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :rating_votes, [:program_rating_id, :user_id], unique: true
    add_index :rating_votes, :helpful
  end
end 