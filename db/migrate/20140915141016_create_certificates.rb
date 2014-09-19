class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.integer :lesson_id
      t.string :code
      t.boolean :enabled, default: true

      t.timestamps
    end
  end
end
