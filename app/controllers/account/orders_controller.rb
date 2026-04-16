class Account::OrdersController < Account::BaseController
  def index
    @orders = current_user.orders.recent.page(params[:page]).per(15)
  end

  def show
    @order = current_user.orders.find(params[:id])
    authorize @order
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    authorize @order, :cancel?
    if @order.update(status: :cancelled, cancelled_at: Time.current)
      redirect_to account_order_path(@order), notice: "Order cancelled."
    else
      redirect_to account_order_path(@order), alert: @order.errors.full_messages.to_sentence
    end
  end
end
