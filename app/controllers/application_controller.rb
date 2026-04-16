class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern

  before_action :set_current_cart

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_current_cart
    @current_cart = if user_signed_in?
                      Cart.find_or_create_by(user: current_user)
                    else
                      Cart.find_or_create_by(session_id: session.id.to_s)
                    end
  end

  def current_cart
    @current_cart
  end
  helper_method :current_cart

  def user_not_authorized
    redirect_back fallback_location: root_path, alert: "You are not authorized for this action."
  end
end
