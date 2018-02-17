json.extract! product, :id, :url, :title, :price, :mrp, :discount, :rating, :rating_count, :review_count, :seller, :image, :devlivery_date, :soldout, :created_at, :updated_at
json.url product_url(product, format: :json)
