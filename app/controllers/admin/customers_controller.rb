class Admin::CustomersController < Admin::BaseController
  def index
    @customers = User.customer.order(created_at: :desc).page(params[:page]).per(25)
  end

  def show
    @customer = User.customer.find(params[:id])
    @orders = @customer.orders.recent.limit(20)
  end
end
