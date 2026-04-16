class CreateProductVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :product_variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :size, null: false
      t.string :color, null: false
      t.integer :stock_quantity, default: 0, null: false
      t.string :sku, null: false
      t.decimal :additional_price, precision: 10, scale: 2, default: 0, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :product_variants, :sku, unique: true
  end
end
