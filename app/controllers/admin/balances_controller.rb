class Admin::BalancesController < Admin::BaseController
  before_action :set_balance, only: [:show, :edit, :update, :destroy]

  def index
    @balances = Balance.amount_dc.paginate(page:params[:page])
  end

  def new
    @balance = Balance.new
  end

  def edit
  end

  def create
    @balance = Balance.new(balance_params)
    if @balance.save
      redirect_to admin_balances_path, notice: '余额添加成功'
    else
      render :new
    end
  end

  def update
    if @balance.update(balance_params)
      redirect_to admin_balances_path, notice: '余额更新成功'
    else
      render :edit
    end
  end

  def destroy
    @balance.destroy
    redirect_to :back, notice: '余额删除成功'
  end

  private
    def set_balance
      @balance = Balance.find(params[:id])
    end

    def balance_params
      params.require(:balance).permit(:block, :balance, :cost)
    end

end
