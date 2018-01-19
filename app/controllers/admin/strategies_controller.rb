class Admin::StrategiesController < Admin::BaseController
  before_action :set_strategy, only:[:edit, :update, :destroy, :change_fettle]

  def index
    @points = Strategy.paginate(page:params[:page])
  end

  def new
    @point = Strategy.new
  end

  def create
    @point = Strategy.new(strategy_params)
    if @point.save
      redirect_to admin_strategies_path, notice: '策略添加成功'
    else
      flash[:warn] = "请完善表单信息"
      render :new
    end
  end

  def edit
  end

  def update
    if @point.update(strategy_params)
      redirect_to admin_strategies_path, notice: '策略更新成功'
    else
      flash[:warn] = "请完善表单信息"
      render :edit
    end
  end

  def destroy
    @point.destroy
    flash[:notice] = "策略删除成功"
    redirect_to :back
  end

  def change_fettle
    if @point.fettle
      @point.fettle = false
      @point.save
    else
      @point.fettle = true
      @point.save
    end
    render json:{code:200}
  end

  private
    def set_strategy
      @point = Strategy.find(params[:id])
    end

    def strategy_params
      params.require(:strategy).permit(:chain_id, :total, :bulk, :procure, :fettle)
    end
end