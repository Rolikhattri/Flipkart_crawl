class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.text :url
      t.text :title
      t.float :price
      t.float :mrp
      t.float :discount
      t.float :rating
      t.string :rating_count
      t.string :review_count
      t.string :seller
      t.text :image
      t.string :devlivery_date
      t.string :soldout
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
