class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
    @discount = BulkDiscount.find(params[:discount_id])
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def create
    @merchant = Merchant.find(params[:id])
    discount = @merchant.bulk_discounts.new(discount_params)

    if params[:quantity_threshold].empty? || params[:discount_percent].empty?
      flash[:notice] = "fields can not be empty"
      render :new
    elsif params[:discount_percent].to_i > 100 || params[:discount_percent].to_i < 1
      flash[:notice] = "discount must be between 1-100%"
      render :new
    else
      discount.save
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
    end
  end

  def destroy
    merchant = Merchant.find(params[:id])
    discount = BulkDiscount.find(params[:discount_id])
    discount.destroy
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end

  def edit
    @discount = BulkDiscount.find(params[:discount_id])
  end

  def update
    @discount = BulkDiscount.find(params[:discount_id])

    if params[:quantity_threshold].empty? || params[:discount_percent].empty?
      flash[:notice] = "fields can not be empty"
      render :edit
    elsif params[:discount_percent].to_i > 100 || params[:discount_percent].to_i < 1
      flash[:notice] = "discount must be between 1-100%"
      render :edit
    else
      @discount.update(discount_params)
      redirect_to "/merchants/#{@discount.merchant_id}/bulk_discounts/#{@discount.id}"
    end
  end

  private

  def discount_params
    params.permit(:discount_percent, :quantity_threshold)
  end
end
