class Admin::DashboardController < Admin::BaseController
  def index
    @recent_orders = Order.recent.limit(10)
    @low_stock_variants = ProductVariant.where("stock_quantity <= ?", 5).order(:stock_quantity).limit(10)
    @sales_by_day = Order.where(status: :delivered).group_by_day(:created_at, last: 14).sum(:total_amount)
    @order_status_distribution = Order.group(:status).count
  end
end
