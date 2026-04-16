class PagesController < ApplicationController
  def about
  end

  def contact
  end

  def create_contact
    redirect_to contact_path, notice: "Thanks! We will get back to you shortly."
  end

  def size_guide
  end

  def shipping
  end

  def returns
  end

  def privacy
  end

  def terms
  end

  def faq
  end
end
