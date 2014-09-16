class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.integer :lesson_id
      t.string :certificate
      t.boolean :enabled

      t.timestamps
    end
  end
end
