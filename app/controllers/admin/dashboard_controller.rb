class Admin::DashboardController < Admin::BaseController

  def index
    block = params[:block] || Chain.first.id
    sta_time = params[:start]
    end_time = params[:end]
    @block = Chain.find(block)
    tickers = @block.markets
    if sta_time.present? && end_time.present?
      tickers = tickers.where("time_stamp >= ? AND time_stamp <= ?",sta_time.to_time.beginning_of_day.to_i,end_time.to_time.end_of_day.to_i)
    end
    @date_array = tickers.map {|x| Time.at(x.time_stamp).strftime('%m-%d %H:%M')}
    @stock_array = tickers.map {|x| [x.o_price,x.c_price,x.l_price,x.h_price] }
  end

  def day_bar
    sta_time = params[:start]
    end_time = params[:end]
    block = params[:block] || Chain.first.id
    @block = Chain.find(block)
    days = @block.day_bars
    if sta_time.present? && end_time.present?
      days = days.where("time_stamp >= ? AND time_stamp <= ?",sta_time.to_time.beginning_of_day.to_i,end_time.to_time.end_of_day.to_i)
    end
    @date_array = days.map {|x| Time.at(x.time_stamp).strftime('%F')}
    @stock_ma5 = days.map {|x| x.indicator.ma5 }
    @stock_ma10 = days.map {|x| x.indicator.ma10 }
    @stock_array = days.map {|x| [x.o_price,x.c_price,x.l_price,x.h_price] }
  end

end
