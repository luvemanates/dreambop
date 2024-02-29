class CartController < ApplicationController
  before_action :get_cart

  def show
    @shipping_address = nil
    if current_user.nil?
      @shipping_address = ShippingAddress.where(:session_id => request.session_options[:id])
    end
    @checkout = Checkout.new(current_user, request.session_options[:id], @shipping_address)
  end

  def update
    @cart_product = CartProduct.new(:cart_id => @cart.id, :product_id => params[:id])
    @cart_product.save
    puts 'cart id is ' + @cart.id.to_s 
    @cart = @cart.reload
    @cart_products = @cart.cart_products
    Rails.cache.fetch( 'cart_' + @cart.id.to_s)
    redirect_to :action => :show
  end

  def delete
    cp = CartProduct.find(params[:id])
    if cp.cart == @cart
      cp.destroy
    end
    @cart.reload
    @cart_products = @cart.cart_products
    #Cache.put 'user_' + current_user.id.to_s + '_cart', @cart
    Cache.put 'cart_' + @cart.id.to_s, @cart_products
    redirect_to :action => :show
  end

protected
  def get_cart
    puts 'in get_cart'
    puts 'session id is ' + request.session[:id].to_s
    puts 'esession id is ' + session[:id].to_s
    #@cart = Cache.get 'user_' + current_user.id.to_s + '_cart'
    #@cart = Rails.cache.fetch( 'user_' + current_user.id.to_s + '_cart')  unless current_user.nil?
    if current_user.nil?
      @cart = Cart.where(:session_id => session[:id]).first
      unless @cart
        @cart = Cart.new(:user_id => 0, :session_id => session[:id])
        @cart.save
      end
    else
      @cart = current_user.cart
      if @cart.nil?
        @cart = Cart.new(:user => current_user)
        @cart.save
      end
    end
    #@cart_products = Rails.cache.fetch( 'cart_' + @cart.id.to_s) do
    #@cart.cart_products
    #end
  end

end
