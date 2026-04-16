class Account::DashboardController < Account::BaseController
  def index
    @orders = current_user.orders.recent.limit(5)
    @addresses = current_user.addresses.limit(3)
    @wishlist_count = current_user.wishlists.count
  end
end
