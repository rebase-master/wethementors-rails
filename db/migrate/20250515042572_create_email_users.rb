class CreateEmailUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :email_users do |t|
      t.string :email, null: false
      t.integer :sent_count, default: 0
      t.timestamps
    end

    add_index :email_users, :email, unique: true
  end
end 