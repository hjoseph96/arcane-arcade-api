class V1::OrdersController < ApiController
  before_action :authenticate, except: [:paid, :complete]
  before_action :check_secret_key, only: [:paid, :complete]
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders
    render_success(data: serialized_order)
  end

  def show
    render_success(data: serialized_order)
  end

  def create
    @order = current_user.orders.new(order_params)

    if current_user.own_game?(order_params[:listing_id], order_params[:platform])
      @order.errors.add(:base, "You already own this game for #{order_params[:platform]} platform.")
      render_error(model: @order)
      return
    end

    if current_user.seller && current_user.seller.listing_ids.include(order_params[:listing_id])
      @order.errors.add(:base, "You can't buy your own game.")
      render_error(model: @order)
      return
    end

    if @order.save
      render_success(data: serialized_order)
    else
      render_error(model: @order)
    end
  end

  def paid
    @order = Order.find_by(escrow_address: params[:escrow_address])
    raise ActiveRecord::RecordNotFound unless @order
    @order.paid!
    head :ok
  end

  def complete
    @order = Order.find_by(escrow_address: params[:escrow_address])
    raise ActiveRecord::RecordNotFound unless @order
    @order.completed!
    head :ok
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def check_secret_key
    secret_key = Rails.application.credentials.NODE_SECRET_KEY
    not_authenticated unless request.headers['Authorization'] == secret_key
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
