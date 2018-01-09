# t.integer "chain_id",   limit: 8
# t.integer "day_bar_id", limit: 8
# t.float   "ma5",        limit: 24
# t.float   "ma10",       limit: 24
# t.float   "macd_diff",  limit: 24
# t.float   "macd_dea",   limit: 24
# t.float   "macd_fast",  limit: 24
# t.float   "macd_slow",  limit: 24

class DayIndicator < ActiveRecord::Base
  after_create :sync_indicator
  has_one :day_bar, class_name:'DayBar',primary_key:'day_bar_id',foreign_key:'id'

  def sync_indicator
    if self.day_bar
      self.day_bar.sync_ma_price
      self.day_bar.sync_macd
    end
  end

end
