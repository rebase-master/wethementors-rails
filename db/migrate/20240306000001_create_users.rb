class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.boolean :admin, default: false
      t.string :type
      t.string :access_token
      t.string :password_digest, null: false
      t.string :registration_key
      t.boolean :confirmed, default: false
      t.string :username, null: false
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.datetime :last_login
      t.boolean :blocked, default: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :registration_key
    add_index :users, :access_token
  end
end 