class Api::MarketsController < ApplicationController

  def hit_markets
    time_stamp = Market.intact_time(Time.now)
    Chain.all.each do |block|
      if block.markets.count > 100
        ticker = block.get_market('15m',1)[0]
        Market.generate(block.id,ticker,time_stamp) if ticker
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
        ticker = block.get_market('1d',1)[0]
        DayBar.generate(block.id,ticker,time_stamp) if ticker
      else
        tickers = block.get_market('1d',500)
        tickers.each do |ticker|
          DayBar.generate(block.id,ticker,Market.intact_time(ticker[6] / 1000))
        end
      end
    end
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

end