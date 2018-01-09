class Admin::ChainsController < Admin::BaseController
  before_action :set_chain, only: [:show, :edit, :update, :destroy]

  def index
    @chains = Chain.paginate(page:params[:page])
  end

  def show
  end

  def new
    @chain = Chain.new
  end

  def edit
  end

  def create
    @chain = Chain.new(chain_params)
    if @chain.save
      redirect_to admin_chains_path, notice: '块链添加成功'
    else
      render :new
    end
  end

  def update
    if @chain.update(chain_params)
      redirect_to admin_chains_path, notice: '块链更新成功'
    else
      render :edit
    end
  end

  def destroy
    @chain.destroy
    redirect_to :back, notice: '块链删除成功'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chain
      @chain = Chain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chain_params
      params.require(:chain).permit(:block, :currency, :title)
    end

end
