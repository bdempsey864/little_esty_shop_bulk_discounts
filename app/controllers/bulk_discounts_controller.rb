class BulkDiscountsController < ApplicationController
  before_action :get_merchant

  def index
    @bulk_discounts = @merchant.bulk_discounts
    @holidays = HolidayService.holidays({country: "US", number: 3})
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @discount = BulkDiscount.new
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.new(percentage: params[:percentage], quantity_threshold: params[:quantity_threshold])
    if discount.save
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
    else
      redirect_to "/merchant/#{@merchant.id}/bulk_discounts/new"
      flash[:alert] = "Error: You must fill in all the blanks"
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.update(percentage: params[:percentage], quantity_threshold: params[:quantity_threshold])
    redirect_to "/merchant/#{merchant.id}/bulk_discounts/#{bulk_discount.id}"
  end

  private
  def get_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
