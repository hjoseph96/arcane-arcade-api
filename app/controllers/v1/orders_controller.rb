class V1::OrdersController < ApplicationController
  before_action :require_login

  def create
    @listing = Listing.find(order_params[:listing_id])

    CryptoConversion.convert(
      coin_amount: 1,
      from_currency: order_params[:coin_type],
      to_currency:
    )
  end

  private

  def order_params
    params.require(:order).permit(
      :listing_id, :buyer_id, :coin_type, :coin_amount, :fiat_currency
    )
  end
end
