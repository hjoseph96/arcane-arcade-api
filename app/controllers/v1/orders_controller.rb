class V1::OrdersController < ApiController
  before_action :authenticate, except: [:paid]
  before_action :check_secret_key, only: [:paid]

  def create
    @order = current_user.orders.new(order_params)

    if @order.save
      render_success(data: serialized_order)
    else
      p @order.errors.full_messages
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

  def paid
    @order = Order.find_by(escrow_address: params[:id])
    raise ActiveRecord::RecordNotFound unless @order
    @order.paid!
    head :ok
  end

  private

  def check_secret_key
    head :unauthorized unless headers['Authorization'] == Rails.application.credentials.node_api[:secret_key]
  end

  def serialized_order
    OrderSerializer.new(@orders || @order).serializable_hash
  end

  def order_params
    params.require(:order).permit(
      :listing_id, :coin_type, :platform
    )
  end
end
