class CreateVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :vote, null: false, default: 0

      t.timestamps
    end
  end
end
