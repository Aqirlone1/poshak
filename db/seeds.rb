require "yaml"
require "faker"
require "open-uri"
require "cgi"

SEED_ROOT = Rails.root.join("db", "seeds")

config = YAML.load_file(SEED_ROOT.join("config.yml")).deep_symbolize_keys
users_yml = YAML.load_file(SEED_ROOT.join("users.yml")).deep_symbolize_keys
categories_yml = YAML.load_file(SEED_ROOT.join("categories.yml")).deep_symbolize_keys
products_yml = YAML.load_file(SEED_ROOT.join("products.yml")).deep_symbolize_keys

PASSWORD = config[:password]
DEFAULT_COUNTRY = config[:default_country]

def weighted_status(weights_hash)
  pool = weights_hash.flat_map { |key, weight| Array.new(weight.to_i, key.to_s) }
  pool.sample
end

def build_order_number
  "PK#{Time.current.strftime('%Y%m%d')}#{SecureRandom.hex(4).upcase}"
end

def attach_remote_product_image(product:, url_templates:, image_index:, fallback_tag:)
  seed_string = "#{product.sku}-#{image_index}"
  urls = url_templates.map do |template|
    format(template, seed: CGI.escape(seed_string), tag: CGI.escape(fallback_tag.to_s.downcase))
  end

  urls.each do |url|
    begin
      file = URI.open(url, open_timeout: 5, read_timeout: 8)
      image = product.product_images.build(
        position: image_index + 1,
        alt_text: "#{product.name} image #{image_index + 1}"
      )
      ext = File.extname(URI.parse(url).path).presence || ".jpg"
      image.image.attach(io: file, filename: "#{product.sku.downcase}-#{image_index + 1}#{ext}", content_type: "image/jpeg")
      image.save!
      return true
    rescue StandardError => e
      Rails.logger.warn("Seed image fetch failed for #{url}: #{e.message}")
    end
  end

  false
end

def ensure_addresses_for(user:, count:, default_country:)
  existing = user.addresses.count
  return if existing >= count

  (count - existing).times do |idx|
    user.addresses.create!(
      address_type: %i[home work other].sample,
      full_name: user.full_name,
      phone_number: user.phone_number.presence || Faker::Number.number(digits: 10),
      address_line1: Faker::Address.street_address,
      address_line2: (idx.even? ? Faker::Address.secondary_address : nil),
      city: Faker::Address.city,
      state: Faker::Address.state,
      postal_code: Faker::Address.zip_code.to_s.gsub(/[^\d]/, "").first(6).ljust(6, "0"),
      country: default_country,
      is_default: user.addresses.empty?
    )
  end
end

puts "Seeding users from YAML..."
users_yml.fetch(:admins, []).each do |admin_attrs|
  admin = User.find_or_initialize_by(email: admin_attrs.fetch(:email))
  admin.assign_attributes(
    first_name: admin_attrs.fetch(:first_name),
    last_name: admin_attrs.fetch(:last_name),
    phone_number: admin_attrs.fetch(:phone_number),
    role: :admin,
    password: PASSWORD,
    password_confirmation: PASSWORD,
    confirmed_at: Time.current
  )
  admin.save!
end

users_yml.fetch(:customers, []).each do |customer_attrs|
  customer = User.find_or_initialize_by(email: customer_attrs.fetch(:email))
  customer.assign_attributes(
    first_name: customer_attrs.fetch(:first_name),
    last_name: customer_attrs.fetch(:last_name),
    phone_number: customer_attrs.fetch(:phone_number),
    role: :customer,
    password: PASSWORD,
    password_confirmation: PASSWORD,
    confirmed_at: Time.current
  )
  customer.save!
end

puts "Generating additional customers..."
config[:generation][:customers_count].times do |i|
  email = "customer#{i + 1}@poshak.test"
  next if User.exists?(email: email)

  User.create!(
    email: email,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone_number: Faker::Number.number(digits: 10),
    role: :customer,
    password: PASSWORD,
    password_confirmation: PASSWORD,
    confirmed_at: Time.current
  )
end

puts "Seeding categories from YAML..."
category_map = {}
categories_yml.fetch(:categories, []).each do |category_attrs|
  category = Category.find_or_initialize_by(name: category_attrs.fetch(:name))
  category.assign_attributes(
    description: category_attrs[:description],
    position: category_attrs[:position] || 0,
    active: true
  )
  category.save!
  category_map[category.name] = {
    category: category,
    gender: category_attrs[:gender].to_s
  }
end

puts "Seeding products/variants/images from YAML config..."
prefixes = products_yml.fetch(:product_name_parts).fetch(:prefix)
items = products_yml.fetch(:product_name_parts).fetch(:item)
suffixes = products_yml.fetch(:product_name_parts).fetch(:suffix)
brands = products_yml.fetch(:brands)
materials = products_yml.fetch(:materials)
care_notes = products_yml.fetch(:care_instructions)
sizes = products_yml.fetch(:variant_sizes)
colors = products_yml.fetch(:variant_colors)
image_templates = products_yml.fetch(:image_sources)

min_price = config[:pricing][:min_price].to_i
max_price = config[:pricing][:max_price].to_i

category_map.each_value do |entry|
  category = entry[:category]
  gender = entry[:gender]
  per_category = config[:generation][:products_per_category].to_i
  variants_per_product = config[:generation][:variants_per_product].to_i
  images_per_product = config[:generation][:images_per_product].to_i

  per_category.times do |idx|
    name = "#{prefixes.sample} #{items.sample} #{suffixes.sample}"
    sku = format("PK-%<cat>s-%<num>03d", cat: category.name.upcase.first(3), num: idx + 1)
    price = rand(min_price..max_price)
    compare_price = price + rand(100..800)

    product = Product.find_or_initialize_by(sku: sku)
    product.assign_attributes(
      name: name,
      category: category,
      gender: gender.presence || "unisex",
      description: Faker::Lorem.paragraph(sentence_count: 3),
      price: price,
      compare_at_price: compare_price,
      brand: brands.sample,
      material: materials.sample,
      care_instructions: care_notes.sample,
      active: true,
      featured: [true, false, false].sample,
      position: idx + 1
    )
    product.save!

    variants_per_product.times do |v_idx|
      variant_sku = "#{product.sku}-#{sizes[v_idx % sizes.length]}-#{colors[v_idx % colors.length].upcase}"
      variant = ProductVariant.find_or_initialize_by(sku: variant_sku)
      variant.assign_attributes(
        product: product,
        size: sizes[v_idx % sizes.length],
        color: colors[v_idx % colors.length],
        stock_quantity: rand(config[:generation][:min_stock_per_variant]..config[:generation][:max_stock_per_variant]),
        additional_price: rand(0..300),
        active: true
      )
      variant.save!
    end

    existing_count = product.product_images.count
    if existing_count < images_per_product
      (existing_count...images_per_product).each do |img_idx|
        attach_remote_product_image(
          product: product,
          url_templates: image_templates,
          image_index: img_idx,
          fallback_tag: product.gender
        )
      end
    end
  end
end

puts "Seeding addresses, carts, wishlists, and orders..."
customers = User.customer.includes(:addresses).to_a
all_products = Product.includes(:product_variants).to_a

customers.each do |customer|
  ensure_addresses_for(
    user: customer,
    count: config[:generation][:addresses_per_customer].to_i,
    default_country: DEFAULT_COUNTRY
  )
  customer.addresses.reload

  cart = Cart.find_or_create_by!(user: customer)
  if rand < config[:generation][:cart_fill_ratio].to_f
    sample_products = all_products.sample(rand(1..3))
    sample_products.each do |product|
      variant = product.product_variants.active.sample
      next unless variant

      cart_item = cart.cart_items.find_or_initialize_by(product: product, product_variant: variant)
      cart_item.quantity = rand(1..2)
      cart_item.save!
    end
  end

  wishlist_target = rand(1..config[:generation][:max_wishlist_items_per_customer].to_i)
  all_products.sample(wishlist_target).each do |product|
    Wishlist.find_or_create_by!(user: customer, product: product)
  end

  max_orders = config[:generation][:max_orders_per_customer].to_i
  target_orders = (customer.id % max_orders) + 1
  existing_orders = customer.orders.count
  next if existing_orders >= target_orders

  (target_orders - existing_orders).times do
    shipping_address = customer.addresses.sample
    billing_address = customer.addresses.sample || shipping_address
    status = weighted_status(config[:order_status_weights])

    order = customer.orders.create!(
      order_number: build_order_number,
      status: status,
      payment_method: "COD",
      payment_status: (status == "delivered" ? :completed : :pending),
      shipping_address: shipping_address,
      billing_address: billing_address
    )

    selected_products = all_products.sample(rand(1..4))
    selected_products.each do |product|
      variant = product.product_variants.active.sample
      next unless variant

      qty = rand(1..3)
      unit_price = variant.final_price
      total_price = unit_price * qty
      order.order_items.create!(
        product: product,
        product_variant: variant,
        quantity: qty,
        unit_price: unit_price,
        total_price: total_price
      )
    end

    subtotal = order.order_items.sum(:total_price)
    shipping_charge = subtotal >= config[:pricing][:free_shipping_threshold].to_f ? 0 : config[:pricing][:shipping_charge].to_f
    tax_amount = (subtotal * config[:pricing][:gst_rate].to_f).round(2)
    total = subtotal + shipping_charge + tax_amount

    time_updates = {}
    time_updates[:shipped_at] = rand(2..7).days.ago if %w[shipped delivered].include?(status)
    time_updates[:delivered_at] = rand(1..2).days.ago if status == "delivered"
    time_updates[:cancelled_at] = rand(1..3).days.ago if status == "cancelled"

    order.update!(
      subtotal: subtotal,
      shipping_charge: shipping_charge,
      tax_amount: tax_amount,
      discount_amount: 0,
      total_amount: total,
      **time_updates
    )
  end
end

puts "Seed complete."
puts "Admin login: admin@poshak.test / #{PASSWORD}"
puts "Customer login: customer@poshak.test / #{PASSWORD}"
