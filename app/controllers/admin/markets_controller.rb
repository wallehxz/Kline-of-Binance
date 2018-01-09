class Admin::MarketsController < Admin::BaseController
  before_action :set_chain
  before_action :set_market, only:[:edit, :update, :destroy]

  def index
    @tickers = Market.where(chain_id:@chain).latest.paginate(page:params[:page])
  end

  def edit
  end

  def update
    if @ticker.update(market_params)
      redirect_to admin_chain_markets_path(@chain), notice: '区块行情更新成功'
    else
      flash[:warn] = "请完善表单信息"
      render :edit
    end
  end

  def destroy
    @ticker.destroy
    flash[:notice] = "区块行情删除成功"
    redirect_to :back
  end

  private
    def set_chain
      @chain = Chain.find(params[:chain_id])
    end

    def set_market
      @ticker = Market.find(params[:id])
    end

    def market_params
      params.require(:market).permit(:chain_id,:bid,:ask,:high,:low,
        :open_buy,:open_sell,:prev_day,:volume,:base_volume,:time_stamp)
    end
end
