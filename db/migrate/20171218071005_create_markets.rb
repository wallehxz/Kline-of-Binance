class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.integer :chain_id, limit:5
      t.float   :o_price
      t.float   :c_price
      t.float   :h_price
      t.float   :l_price
      t.float   :volume
      t.date    :diary
      t.decimal :time_stamp, precision:15
    end

    add_index :markets, :time_stamp
  end
end
