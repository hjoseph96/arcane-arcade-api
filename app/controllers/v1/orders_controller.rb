class V1::OrdersController < ApiController
  before_action :authenticate, except: [:paid]
  before_action :check_secret_key, only: [:paid]
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
