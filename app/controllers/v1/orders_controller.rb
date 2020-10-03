class V1::OrdersController < ApplicationController
  before_action :require_login

  def create
    @order = Order.new(order_params)

    @order.status   = :in_progress
    @order.buyer_id = current_user.id
    @order.coin_price_at_time = OrderService.current_coin_price(
      coin_type: @order.coin_type,
      fiat_currency: @order.fiat_currency
    )
    @order.expires_at = 1.hour.from_now
    @order.escrow_address = OrderService.create_escrow(
      coin_type: @order.coin_type,
      expires_at: @order.expires_at,
      deposit_amount: @order.coin_amount
    )

    if @order.save
      render_success(data: @order)
    else
      render_error(model: @order)
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :listing_id, :coin_type, :coin_amount, :fiat_currency
    )
  end
end
