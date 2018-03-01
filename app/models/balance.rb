# t.string   "block",      limit: 255
# t.float    "balance",    limit: 24
# t.float    "cost",       limit: 24 成本等值 USDT
# t.datetime "created_at",  null: false
# t.datetime "updated_at",  null: false
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
class Balance < ActiveRecord::Base
  validates_presence_of :block, :balance
  scope :amount_dc, -> { order(balance: :desc)}
  # Balance.sync_balances
  def self.sync_balances
    chains = Chain.all.map{|x| x.block } << 'USDT'
    balances = Balance.remote_balances
    balances = balances['balances']
    balances.each do |balance|
      if balance['free'].to_f > 0
        Balance.generate(balance) if chains.include?(balance['asset'])
      end
    end
  end

  # Balance.remote_balances
  def self.remote_balances
    balance_url = 'https://api.binance.com/api/v3/account'
    timestamp = (Time.now.to_f * 1000).to_i
    params_stirng = "recvWindow=5000&timestamp=#{timestamp}"
    res = Faraday.get do |req|
      req.url balance_url
      req.headers['X-MBX-APIKEY'] = Settings.apiKey
      req.params['recvWindow'] = 5000
      req.params['timestamp'] = timestamp
      req.params['signature'] = Bill.signed(params_stirng)
    end
    JSON.parse(res.body)
  end

  def self.generate(balance)
    bal = Balance.find_by_block(balance['asset']) || Balance.new
    bal.block = balance['asset']
    bal.balance = balance['free'].to_f
    bal.cost = 0 if bal.cost.nil?
    bal.save
  end

end
