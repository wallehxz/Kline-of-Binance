# t.string   "block",      limit: 255
# t.string   "currency",   limit: 255
# t.string   "title",      limit: 255
# t.datetime "created_at",             null: false
# t.datetime "updated_at",             null: false
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class Chain < ActiveRecord::Base
  self.per_page = 10
  validates_presence_of :block, :currency, :title
  validates_uniqueness_of :block, scope: :currency
  has_many :markets, class_name:'Market'
  has_many :bills, class_name:'Bill'
  has_many :day_bars, class_name:'DayBar'
  has_one  :usdt, class_name:'Chain', foreign_key:'block', primary_key: 'currency'
  has_one  :strategy
  has_one  :balance, class_name:'Balance', primary_key: 'block', foreign_key:'block'
  has_one  :wallet, class_name:'Balance', primary_key: 'currency', foreign_key:'block'

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

  def high
    self.markets.timing.last(288).map {|x| x.c_price }.max
  end

  def low
    self.markets.timing.last(288).map {|x| x.c_price }.min
  end

  def last
    self.markets.timing.last.c_price
  end

  def retain_balance
    self.balance.try(:balance) || 0
  end

  def retain_money
    self.wallet.try(:balance) || 0
  end

  def total_bulk
    self.strategy.try(:bulk) || 0
  end

  def total_money
    self.strategy.try(:total) || 0
  end

  def procure
    self.strategy.try(:procure) || 0
  end

  def usdt_price
    if self.currency != 'USDT'
      usdt = self.usdt.last
      return (usdt * self.last).round(2)
    else
      return self.last.round(2)
    end
  end

  def self.wechat_notice(title,content)
    push_url = 'https://sc.ftqq.com/SCU16737Tfd4e2c97f2d967e26cd629f1f87ca4345a1bc153e6755.send'
    res = Faraday.get do |req|
      req.url push_url
      req.params['text'] = title
      req.params['desp'] = content
    end
  end

  def self.sms_yunpian(mobile,content)
    yunpian = 'https://sms.yunpian.com/v2/sms/tpl_single_send.json'
    params = {}
    params[:apikey] = Settings.yunpian_key
    params[:tpl_id] = '1950240'
    params[:mobile] = mobile
    params[:tpl_value] = URI::escape('#report#') + '='+ URI::escape(content)
    Faraday.send(:post,yunpian, params)
  end

end
