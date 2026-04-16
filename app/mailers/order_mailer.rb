class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    mail(to: @order.user.email, subject: "Your Poshak order #{@order.order_number} is confirmed")
  end
end
