class AddPriceToStrategy < ActiveRecord::Migration
  def change
    add_column :strategies, :in_price, :float
    add_column :strategies, :out_price, :float
  end
end
