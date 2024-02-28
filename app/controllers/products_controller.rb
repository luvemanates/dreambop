class ProductsController < ApplicationController
  def feed
    @products = Rails.cache.fetch( 'products_feed') do
      Product.find(:all, :limit => 10)
    end
    respond_to do |format|
      format.rss  { render :layout => false }
      format.xml { render 'feed.rss', :layout => false}
    end
  end

  # GET /products
  # GET /products.xml
  def index
    page = params[:page] || 1
    @featured_products = Rails.cache.fetch('featured_prod_8') do
      Product.all.where('category_id = 272').includes(:product_images).order('msrp ASC').limit(8)
    end
    @new_products = Rails.cache.fetch( 'new_prod_8') do
      Product.all.includes(:product_images).order('created_at DESC').limit(8)
    end
    @top_sellers = Rails.cache.fetch( 'top_seller_8' ) do
      Product.all.where('category_id in (564, 567)').includes(:product_images).order('msrp, created_at DESC').limit(8)
    end
    @recommended = Rails.cache.fetch( 'recommended_8' ) do
      Product.all.where('category_id = 274').includes(:product_images).order('msrp, created_at DESC').limit(8)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @products }
    end
  end
  
  def featured
    @section_title = "FEATURED PRODUCTS"
    page = params[:page] || 1
    @products = Rails.cache.fetch( 'featured_prod_pg_' + page.to_s ) do
      Product.where('category_id = 272').order('msrp ASC').includes(:product_images).paginate(:page => page)
    end
  end

  def new
    @section_title = "NEWEST PRODUCTS"
    page = params[:page] || 1
    @products = Rails.cache.fetch( 'newest_prod_pg_' + page.to_s) do
      Product.all.order('created_at DESC').includes(:product_images).paginate(:page => page)
    end
    render :featured
  end

  def top_sellers
    @section_title = "TOP SELLERS"
    page = params[:page] || 1
    @products = Rails.cache.fetch( 'top_prod_pg_' + page.to_s ) do
      Product.where('category_id in (564, 567)').order('msrp ASC').includes(:product_images).paginate(:page => page)
    end
    render :featured
  end

  def recommended
    @section_title = "RECOMMENDED PRODUCTS"
    page = params[:page] || 1
    @products = Rails.cache.fetch( 'rec_prod_pg_' + page.to_s ) do
      Product.where('category_id = 274').order('msrp, created_at DESC').includes(:product_images).paginate(:page => page)
    end
    render :featured
  end
  # GET /products/1
  # GET /products/1.xml
  def show
    @product = Product.where(:id => params[:id]).includes(:ds_vendor, :product_images, :category).first
      puts 'product is ' + @product.title.to_s
      puts 'category is ' + @product.category.to_s
      Rails.cache.fetch( 'product_' + params[:id].to_s + '_breadcrumb') do
        @breadcrumb = @product.category.breadcrumb
      end
    @related_products = Product.all.where( [ 'products.manufacturer = ? and products.id != ?', @product.manufacturer, @product.id]).includes(:product_images).limit(4)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @product }
    end
  end

  # GET /products/new
  # GET /products/new.xml
=begin
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @product }
    end
  end
=end

  # GET /products/1/edit
=begin
  def edit
    @product = Product.find(params[:id])
  end
=end

  # POST /products
  # POST /products.xml
=begin
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to(@product, :notice => 'Product was successfully created.') }
        format.xml  { render :xml => @product, :status => :created, :location => @product }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end
=end

  # PUT /products/1
  # PUT /products/1.xml
=begin
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors, :status => :unprocessable_entity }
      end
    end
  end
=end

  # DELETE /products/1
  # DELETE /products/1.xml
=begin
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to(products_url) }
      format.xml  { head :ok }
    end
  end
=end
end
