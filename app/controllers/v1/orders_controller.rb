class V1::OrdersController < ApiController
  before_action :authenticate

  def create
    p order_params

    @order = current_user.orders.new(order_params)

    if @order.save
      @order.generate_qr!
      render_success(data: serialized_order)
    else
      render_error(model: @order)
    end
  end

  def show
    @order = Order.find(params[:id])

    render_success(data: serialized_order)
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
    OrderSerializer.new(@orders || @order).serializable_hash
  end

  def order_params
    params.require(:order).permit(
      :listing_id, :coin_type,
    )
  end
end
