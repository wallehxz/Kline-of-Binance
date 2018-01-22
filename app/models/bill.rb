# t.integer  "chain_id",   limit: 8
# t.integer  "stamp",      limit: 4
# t.integer  "state",      limit: 4
# t.float    "amount",     limit: 24
# t.float    "univalent",  limit: 24
# t.float    "expense",    limit: 24
# t.datetime "created_at",  null: false
# t.datetime "updated_at",  null: false
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class Bill < ActiveRecord::Base
  belongs_to :chain
  validates_presence_of :chain_id, :amount, :univalent, :stamp
  after_create :caculate_expense
  after_save :sync_order

  def state_cn
    {1=>'未完成',0=>'已完成'}[self.state]
  end

  def stamp_cn
    {1=>'买入',0=>'卖出'}[self.stamp]
  end

  def buy?
    return true if self.stamp == 1
  end

  def sell?
    return true if self.stamp == 0
  end

  # Bill.buy_order('APPCETH',10,0.0001)
  def self.buy_order(symbol,quantity,price)
    Bill.remote_order(symbol,'BUY',quantity,price)
  end
  # Bill.sell_order('APPCETH',10,0.15)
  def self.sell_order(symbol,quantity,price)
    Bill.remote_order(symbol,'SELL',quantity,price)
  end

  def self.remote_order(symbol,side,quantity,price)
    order_url = 'https://api.binance.com/api/v3/order'
    timestamp = (Time.now.to_f * 1000).to_i
    params_stirng = "price=#{price}&quantity=#{quantity}&recvWindow=5000&side=#{side}&symbol=#{symbol}&timeInForce=GTC&timestamp=#{timestamp}&type=LIMIT"
    res = Faraday.post do |req|
      req.url order_url
      req.headers['X-MBX-APIKEY'] = Settings.apiKey
      req.params['symbol'] = symbol
      req.params['side'] = side
      req.params['type'] = 'LIMIT'
      req.params['quantity'] = quantity
      req.params['price'] = price
      req.params['recvWindow'] = 5000
      req.params['timeInForce'] = 'GTC'
      req.params['timestamp'] = timestamp
      req.params['signature'] = Bill.signed(params_stirng)
    end
    JSON.parse(res.body)
  end

  def self.signed(data)
    key = Settings.apiSecret
    digest = OpenSSL::Digest.new('sha256')
    return OpenSSL::HMAC.hexdigest(digest, key, data)
  end

  def caculate_expense
    if self.expense.nil?
      self.update_attributes(expense: self.amount * self.univalent)
    end
  end

  def sync_order
    if self.state.nil?
      res = {}
      if self.buy?
        res = Bill.buy_order(self.chain.symbol,self.amount,self.univalent)
      elsif self.sell?
        res = Bill.sell_order(self.chain.symbol,self.amount,self.univalent)
      end
      if res['code']
        self.update_attributes(state:1)
      else
        self.update_attributes(state:0)
        self.sync_balance rescue nil
      end
    end
  end

  def sync_balance
    if self.buy?
      balance = self.chain.balance
      balance.balance = balance.balance + self.amount
      balance.cost = balance.cost + (self.amount * self.chain.usdt_price)
      balance.save
      wallet = self.chain.wallet
      wallet.balance = wallet.balance - self.expense
      wallet.cost = wallet.cost - (self.amount * self.chain.usdt_price)
      wallet.save
    elsif self.sell?
      balance = self.chain.balance
      balance.balance = balance.balance - self.amount
      balance.cost = balance.cost - (self.amount * self.chain.usdt_price)
      balance.save
      wallet = self.chain.wallet
      wallet.balance = wallet.balance + self.expense
      wallet.cost = wallet.cost + (self.amount * self.chain.usdt_price)
      wallet.save
    end
  end

end
