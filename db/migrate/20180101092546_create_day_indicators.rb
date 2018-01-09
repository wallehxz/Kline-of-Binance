class CreateDayIndicators < ActiveRecord::Migration
  def change
    create_table :day_indicators do |t|
      t.integer :chain_id, limit:5
      t.integer :day_bar_id, limit:5
      t.float   :ma5
      t.float   :ma10
      t.float   :macd_diff
      t.float   :macd_dea
      t.float   :macd_fast
      t.float   :macd_slow
    end
  end
end
