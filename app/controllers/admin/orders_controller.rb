class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: %i[show update_status invoice]

  def index
    @q = Order.includes(:user).ransack(params[:q])
    @orders = @q.result(distinct: true).recent.page(params[:page]).per(25)
  end

  def show
  end

  def update_status
    authorize @order, :update_status?
    status = params[:status].to_s
    update_attrs = { status: status }
    update_attrs[:shipped_at] = Time.current if status == "shipped"
    update_attrs[:delivered_at] = Time.current if status == "delivered"
    update_attrs[:cancelled_at] = Time.current if status == "cancelled"

    if @order.update(update_attrs)
      redirect_to admin_order_path(@order), notice: "Order status updated."
    else
      redirect_to admin_order_path(@order), alert: @order.errors.full_messages.to_sentence
    end
  end

  def invoice
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
