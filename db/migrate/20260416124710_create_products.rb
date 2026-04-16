class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :compare_at_price, precision: 10, scale: 2
      t.string :sku, null: false
      t.references :category, null: false, foreign_key: true
      t.integer :gender, default: 2, null: false
      t.string :brand
      t.string :material
      t.text :care_instructions
      t.boolean :active, default: true, null: false
      t.boolean :featured, default: false, null: false
      t.integer :position, default: 0, null: false

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true
  end
end
