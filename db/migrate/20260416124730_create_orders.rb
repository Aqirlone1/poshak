class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.decimal :subtotal, precision: 10, scale: 2, default: 0, null: false
      t.decimal :shipping_charge, precision: 10, scale: 2, default: 0, null: false
      t.decimal :tax_amount, precision: 10, scale: 2, default: 0, null: false
      t.decimal :discount_amount, precision: 10, scale: 2, default: 0, null: false
      t.decimal :total_amount, precision: 10, scale: 2, default: 0, null: false
      t.string :payment_method, default: "COD", null: false
      t.integer :payment_status, default: 0, null: false
      t.text :notes
      t.references :shipping_address, null: false, foreign_key: { to_table: :addresses }
      t.references :billing_address, null: false, foreign_key: { to_table: :addresses }
      t.datetime :shipped_at
      t.datetime :delivered_at
      t.datetime :cancelled_at

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
  end
end
