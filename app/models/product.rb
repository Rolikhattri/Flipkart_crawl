require 'rubygems'
require 'csv'
require 'open-uri'
require 'nokogiri'


class Product < ActiveRecord::Base
	belongs_to :user

	def self.crawl_data(url)
    	params = {}
		link = url
		file = Nokogiri::HTML(open("#{link}"))
	    title=''
	    title = file.css('._3eAQiD').text if !file.css('._3eAQiD').nil?
	    params[:title] = title
	    image=''
	    image = file.css('.sfescn').attr('src').value if !file.css('.sfescn').nil?
	    params[:image] = image
	    seller = ''
	    seller = file.css('._3HGjxn').text if !file.css('._3HGjxn').nil?
	    params[:seller] = seller
	   	strikePrice = 0
			if !file.css('._3auQ3N._16fZeb').empty?
				strikePrice = file.css('._3auQ3N._16fZeb').text.delete!("^\u{0000}-\u{007F}").gsub(',','').to_f if !file.css('._3auQ3N._16fZeb').nil? 
				params[:mrp] = strikePrice
			end
	    lowest_price = 0
	    lowestPrice = 0
		lowest_price = file.css('._1vC4OE._37U4_g').text if !file.css('._1vC4OE._37U4_g').nil?
		if lowest_price !=0
		   lowest_price= lowest_price.delete!("^\u{0000}-\u{007F}")
		   lowestPrice= lowest_price.gsub(',','').to_f if !lowest_price.nil?
		end
		params[:price] = lowestPrice
      	discount = ((strikePrice - lowestPrice)*100/strikePrice).round(2) if (strikePrice!=0)
      	params[:discount] = discount
		sold_out=''
		sold_out = file.css('._3xgqrA').text if !file.css('._3xgqrA').nil?
  		sold_out='No' if sold_out ==''
		params[:soldout] = sold_out
		
		delivery_date=''
		delivery_date = file.css('._3nCwDW').text if !file.css('._3nCwDW').nil?
		params[:devlivery_date] = delivery_date
	    avg_rating ='0'
	    avg_rating = file.css('._1i0wk8').text if !file.css('._1i0wk8').nil? 
	    params[:rating] = avg_rating.strip.to_f
	    count='0'
	    rating_count ='0'
	    review_count ='0'
	    if avg_rating !='0' and avg_rating!=''
		    count = file.css('._38sUEc').text if !file.css('._38sUEc').nil?
		    if count !='0' and count!=''
			   rating_count = count.split('Ratings')[0] 
			   review_count = count.split(' Reviews')[0].split('&')[1].delete!("^\u{0000}-\u{007F}")
			end
		end
		params[:rating_count] = rating_count
		params[:review_count] = review_count
    	params[:url] = link

    	return params
	end

	def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end
  
end
