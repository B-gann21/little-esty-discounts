class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:id])
  end

  def show
    @discount = BulkDiscount.find(params[:discount_id])
  end
end
