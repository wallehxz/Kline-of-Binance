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
    time_stamp = Market.intact_time(Time.now)
    Chain.all.each do |block|
      if block.day_bars.count > 30
        ticker = block.get_market('1d',2)[0]
        DayBar.generate(block.id,ticker,time_stamp) if ticker
      else
        tickers = block.get_market('1d',500)
        tickers.each do |ticker|
          DayBar.generate(block.id,ticker,Market.intact_time(ticker[6] / 1000))
        end
      end
    end
    hit_clear_week
    render json:{code:200}
  end

  private

    def quote_report(block)
      if block.last == block.high
        title = "#{block.block} 最高价"
        content = "[一价格 : #{block.last} #{block.currency}一]；[一价值: #{block.usdt_price} USDT一]；"
        Chain.wechat_notice(title,content)
      elsif block.last == block.low
        title = "#{block.block} 最低价"
        content = "[一价格 : #{block.last} #{block.currency}一]；[一价值: #{block.usdt_price} USDT一]；"
        Chain.wechat_notice(title,content)
      end
    end

    def hit_clear_week
      Chain.all.each do |block|
        if block.markets.count > 762
          block.markets.timing.first(96).destroy_all
        end
      end
    end

end