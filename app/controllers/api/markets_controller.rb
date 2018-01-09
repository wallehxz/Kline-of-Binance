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
end