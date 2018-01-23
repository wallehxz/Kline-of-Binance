class Api::MarketsController < ApplicationController

  def hit_markets
    time_stamp = Market.intact_time(Time.now)
    Chain.all.each do |block|
      if block.markets.count > 100
        ticker = block.get_market('15m',2)
        ticker_0 = ticker[0]
        ticker_1 = ticker[1]
        if time_stamp - ticker_0[0] / 1000 > 960
          ticker_0 = ticker_1
        end
        Market.generate(block.id,ticker_0,time_stamp) if ticker_0
      else
        tickers = block.get_market('15m',500)
        tickers.each do |ticker|
          Market.generate(block.id,ticker,Market.intact_time(ticker[6] / 1000))
        end
      end
      quote_report(block) rescue nil
    end

    render json:{code:200}
  end

  def hit_day_bar
    Chain.all.each do |block|
      if block.day_bars.count > 30
        ticker = block.get_market('1d',2)[0]
        DayBar.generate(block.id,ticker,Market.intact_time(ticker[6] / 1000)) if ticker
      else
        tickers = block.get_market('1d',500)
        tickers.each do |ticker|
          DayBar.generate(block.id,ticker,Market.intact_time(ticker[6] / 1000))
        end
      end
    end
    hit_clear_week
    hit_balances
    render json:{code:200}
  end

  private

    def quote_report(block)
      if block.last == block.high
        title = "#{block.block} 最高价"
        content = "▶价格 : #{block.last} #{block.currency}；▶价值: #{block.usdt_price} USDT ；▍"
        Chain.wechat_notice(title,content)
        if block.strategy.try(:fettle)
          quotes_out(block)
        end
      elsif block.last == block.low
        title = "#{block.block} 最低价"
        content = "▶ 价格 : #{block.last} #{block.currency}一]；▶价值: #{block.usdt_price} USDT；▍"
        Chain.wechat_notice(title,content)
        if block.strategy.try(:fettle)
          quotes_in(block)
        end
      end
    end

    def hit_clear_week
      Chain.all.each do |block|
        if block.markets.count > 480
          total = block.markets.timing.count
          block.markets.timing.first(total - 480).map {|x| x.destroy }
        end
      end
    end

    def hit_balances
      Balance.sync_balances
    end

    def quotes_in(block)
      in_price = block.strategy.in_price
      bulk = block.total_bulk
      balance = block.retain_balance
      money = block.retain_money
      usdt_price = block.usdt_price
      last_price = block.last
      procure = block.procure
      amount = (procure / usdt_price).round(2)
      if bulk > balance && last_price <= in_price
        if money > amount * last_price
          buy_chain(block.id,amount,last_price)
        elsif money < amount * last_price
          amount = (money * 0.985 / last_price).round(2)
          buy_chain(block.id,amount,last_price)
        end
      end
    end

    def quotes_out(block)
      out_price = block.strategy.out_price
      balance = block.retain_balance
      money = block.retain_money
      usdt_price = block.usdt_price
      last_price = block.last
      procure = block.procure
      amount = (procure / usdt_price).round(2)
      if last_price >= out_price
        if balance > amount
          sell_chain(block.id,amount,last_price)
        else
          amount = balance.to_d.round(2,:truncate).to_f
          sell_chain(block.id,amount,last_price)
        end
      end
    end

    def buy_chain(block,amount,univalent)
      bill = Bill.new
      bill.chain_id = block
      bill.stamp = 1
      bill.amount = amount
      bill.univalent = univalent
      bill.save
    end

    def sell_chain(block,amount,univalent)
      bill = Bill.new
      bill.chain_id = block
      bill.stamp = 0
      bill.amount = amount
      bill.univalent = univalent
      bill.save
    end

end