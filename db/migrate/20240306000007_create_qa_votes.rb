class CreateQaVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :qa_votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :votable, polymorphic: true, null: false
      t.integer :vote, null: false, default: 0
      t.timestamps
    end

    add_index :qa_votes, [:votable_type, :votable_id]
    add_index :qa_votes, [:user_id, :votable_type, :votable_id], unique: true
  end
end 