class Admin::ReportsController < Admin::BaseController
  def index
    @sales_daily = Order.group_by_day(:created_at, last: 30).sum(:total_amount)
    @sales_monthly = Order.group_by_month(:created_at, last: 6).sum(:total_amount)
    @top_products = OrderItem.joins(:product).group("products.name").order("SUM(order_items.quantity) DESC").limit(10).sum(:quantity)
  end
end
