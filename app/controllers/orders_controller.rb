class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = policy_scope(Order).recent.page(params[:page]).per(20)
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
  end
end
