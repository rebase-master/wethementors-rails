class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true, null: false
      t.references :actor, polymorphic: true
      t.string :type, null: false
      t.jsonb :data, default: {}
      t.datetime :read_at
      t.boolean :email_sent, default: false
      t.timestamps
    end

    add_index :notifications, [:recipient_type, :recipient_id]
    add_index :notifications, [:actor_type, :actor_id]
    add_index :notifications, :type
    add_index :notifications, :read_at
    add_index :notifications, :email_sent
  end
end 