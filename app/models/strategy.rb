# t.integer "chain_id", limit: 4
# t.float   "total",    limit: 24 #持有数量等值 USDT
# t.float   "bulk",     limit: 24 #持有数量
# t.float   "procure",  limit: 24 #单次购买的等值 USDT
# t.float   "in_price",  limit: 24 #买入的最高价
# t.float   "out_price", limit: 24 #卖出的最低价
# t.boolean "fettle"

class Strategy  < ActiveRecord::Base
  belongs_to :chain
  self.per_page = 10

end