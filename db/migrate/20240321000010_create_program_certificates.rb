class CreateProgramCertificates < ActiveRecord::Migration[7.1]
  def change
    create_table :program_certificates do |t|
      t.references :program, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :certificate_number, null: false
      t.datetime :issued_at, null: false
      t.datetime :expires_at
      t.string :status, null: false, default: 'active'
      t.string :verification_code, null: false
      t.jsonb :metadata, default: {}
      t.jsonb :achievement_data, default: {}

      t.timestamps
    end

    add_index :program_certificates, :certificate_number, unique: true
    add_index :program_certificates, :verification_code, unique: true
    add_index :program_certificates, :status
    add_index :program_certificates, [:program_id, :user_id], unique: true
  end
end 