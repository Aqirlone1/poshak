module ApplicationHelper
  def nav_link_classes(active)
    base = "rounded-full px-3 py-1.5 text-sm font-semibold transition"
    active ? "#{base} bg-neutral-900 text-white shadow-sm" : "#{base} text-neutral-700 hover:bg-neutral-100 hover:text-black"
  end

  def nav_link_mobile_classes(active)
    base = "block rounded-xl px-3 py-2 text-sm font-semibold transition"
    active ? "#{base} bg-neutral-900 text-white" : "#{base} text-neutral-700 hover:bg-neutral-100 hover:text-black"
  end

  def nav_active_for?(section)
    path = request.path
    case section
    when :home
      path == root_path
    when :products
      path.start_with?(products_path)
    when :categories
      path.start_with?(categories_path)
    when :wishlist
      path.start_with?(wishlists_path)
    when :account
      path.start_with?("/account")
    else
      false
    end
  end
end
