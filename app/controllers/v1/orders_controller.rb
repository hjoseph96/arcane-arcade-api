class V1::OrdersController < ApiController
  before_action :authenticate

  def create
    @order = Order.new(order_params)

    @order.status   = :in_progress
    @order.buyer_id = current_user.id
    @order.coin_price_at_time = OrderService.current_coin_price(
      coin_type: @order.coin_type,
      fiat_currency: @order.fiat_currency
    )
    @order.expires_at = 1.hour.from_now

    destination_address = @order.seller.destination_addresses[@order.coin_type]
    @order.escrow_address = OrderService.create_escrow(
      order: @order, 
      destination_address: destination_address
    )

    if @order.save
      @order.generate_qr!
      render_success(data: @order)
    else
      render_error(model: @order)
    end
  end

  def show
    @order = Order.find(params[:id])

    if @order
      render_success(data: OrderSerializer.new(@order))
    else
      render_error(model: @order, status: :not_found)
    end
  end

  def payment_status
    @order = Order.find(params[:id])

    address = OrderService.fetch_address(
      coin_type: @order.coin_type,
      escrow_address: @order.escrow_address
    )

    if address
      render_success data: { active: address.active }
    else
      render_error status: :not_found
    end
  end

  private

  def serialized_order
    OrderSerializer.new(@orders || @order).serializable_hash[:data]
  end

  def order_params
    params.require(:order).permit(
      :listing_id, :coin_type, :coin_amount, :fiat_currency
    )
  end
end
