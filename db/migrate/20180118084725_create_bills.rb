class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.integer  :chain_id, limit:5
      t.integer  :stamp
      t.integer  :state
      t.float    :amount
      t.float    :univalent
      t.float    :expense

      t.timestamps null: false
    end
  end
end
