class ManufacturersController < ApplicationController

  def index
    @manufacturers = Rails.cache.fetch( 'manufacturers' ) do 
      Product.all.select( 'DISTINCT manufacturer').includes(:product_images) 
    end
  end

  def show
    redirect_to :action => :index and return if params[:id].nil? or params[:id].empty?
    @manufacturer = params[:id].gsub(/\+/, ' ')
    page = params[:page] || 1
    @products = Rails.cache.fetch( 'manufacturer_' + params[:id] + '_products_page' + page.to_s ) do
      Product.where(['manufacturer = ?', @manufacturer]).order('msrp ASC').includes(:product_images).paginate(:page => page)
    end
  end

end
