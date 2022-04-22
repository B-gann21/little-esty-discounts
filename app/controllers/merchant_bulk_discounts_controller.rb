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
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/new"
    elsif params[:discount_percent].to_i > 100 || params[:discount_percent].to_i < 1
      flash[:notice] = "discount must be between 1-100%"
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts/new"
    else
      discount.save
      redirect_to "/merchants/#{@merchant.id}/bulk_discounts"
    end
  end

  private

  def discount_params
    params.permit(:discount_percent, :quantity_threshold)
  end
end
