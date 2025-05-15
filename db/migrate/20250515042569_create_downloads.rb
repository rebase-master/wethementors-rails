class CreateDownloads < ActiveRecord::Migration[7.2]
  def change
    create_table :downloads do |t|
      t.string :resource, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :downloads, :resource
  end
end 