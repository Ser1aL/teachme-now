class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :campaign
      t.string :ip

      t.timestamps
    end
    add_index :visits, :campaign_id
  end
end
