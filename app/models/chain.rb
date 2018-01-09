# t.string   "block",      limit: 255
# t.string   "currency",   limit: 255
# t.string   "title",      limit: 255
# t.datetime "created_at",             null: false
# t.datetime "updated_at",             null: false
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class Chain < ActiveRecord::Base

  validates_presence_of :block, :currency, :title
  validates_uniqueness_of :block, scope: :currency
  has_many :markets, class_name:'Market'
  has_many :day_bars, class_name:'DayBar'

  def market_name
    "#{self.block}-#{self.currency}"
  end

  def symbol
    "#{self.block}#{self.currency}"
  end

  def get_market(interval,amount)
    market_url = 'https://api.binance.com/api/v1/klines'
    res = Faraday.get do |req|
      req.url market_url
      req.params['symbol'] = self.symbol
      req.params['interval'] = interval
      req.params['limit'] = amount
    end
    current = JSON.parse(res.body)
  end

end
