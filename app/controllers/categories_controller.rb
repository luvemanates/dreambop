class CategoriesController < ApplicationController

  def sub
    @category = params[:id]
    @category = "all" if @category.nil? or @category == '' or @category == "All"
    @category = Rails.cache.fetch( 'category_' + @category) do
      Category.find_by_name(params[:id])
    end

    @breadcrumb = Rails.cache.fetch( 'product_' + params[:id].to_s + '_breadcrumb') do
      @category.breadcrumb
    end

    @categories = Rails.cache.fetch( 'category_' + @category.name + '_children') do
      @category.children
    end
  end

  def index
    page = params[:page] || 1
    @category = params[:id]
    @categories = []
    @category = Category.where( :name => "all").first if @category.nil? or @category == '' or @category == "All"

    @category = Rails.cache.fetch('category_' + @category) do
      cat = Category.where(:name => Category.db_safe(params[:id])).first
      cat = @category if cat.nil?
      cat
    end
    if @category.blank?
      @category = Category.where(:name => params[:id]).first
    end
    #@category = Rails.cache.fetch('category_' + @category.linkify) do
    #  @category
    #end

    #@categories = Rails.cache.fetch( 'category_' + @category.linkify + '_allchildren' ) do
    #  @category.all_children << @category
    #  @categoay.all_children
    #end
    @categories = @category.all_children

    @products = Rails.cache.fetch( 'category_' + @category.linkify + '_products_page_' + page.to_s) do
      Product.where(['category_id in (?)', @categories]).order('msrp DESC').includes(:product_image).paginate(:page => page)
    end

    @breadcrumb = Rails.cache.fetch( 'product_' + params[:id].to_s + '_breadcrumb' ) do
      @category.breadcrumb
      Rails.cache.fetch('product_' + @category.linkify + '_breadcrumb') do
        @category.breadcrumb
      end
    end
  end

end
