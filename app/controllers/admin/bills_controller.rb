class Admin::BillsController < Admin::BaseController
  before_action :set_bill, only:[:edit, :update, :destroy]

  def index
    @bills = Bill.paginate(page:params[:page])
  end

  def new
  end

  def create
    @bill = Bill.new(bill_params)
    if @bill.save
      redirect_to admin_bills_path, notice: '添加订单成功'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @bill.update(bill_params)
      redirect_to admin_bills_path, notice: '更新订单成功'
    else
      flash[:warn] = "请完善表单信息"
      render :edit
    end
  end

  def destroy
    @bill.destroy
    flash[:notice] = "订单删除成功"
    redirect_to :back
  end

  private

    def set_bill
      @bill = Bill.find(params[:id])
    end

    def bill_params
      params.require(:bill).permit(:chain_id, :stamp, :state, :amount, :univalent, :expense)
    end
end
