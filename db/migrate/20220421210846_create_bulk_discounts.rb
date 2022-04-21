class CreateBulkDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_discounts do |t|
      t.references :merchant, foreign_key: true
      t.integer :quantity_threshold
      t.integer :discount_percent

      t.timestamps
    end
  end
end
