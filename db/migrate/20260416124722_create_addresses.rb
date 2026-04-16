class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :address_type, default: 0, null: false
      t.string :full_name, null: false
      t.string :phone_number, null: false
      t.string :address_line1, null: false
      t.string :address_line2
      t.string :city, null: false
      t.string :state, null: false
      t.string :postal_code, null: false
      t.string :country, default: "India", null: false
      t.boolean :is_default, default: false, null: false

      t.timestamps
    end
  end
end
