class V1::Admins::SellersController < V1::AdminsController
  before_action :set_seller, only: [:update]

  def index
    @sellers = Seller.pending
    render_success(data: serialized_sellers)
  end

  def update
    if @seller.update(update_params)
      head :ok
    else
      render_error(model: @seller)
    end
  end

  private

  def update_params
    params.fetch(:seller, {}).permit(:status)
  end

  def set_seller
    @seller = Seller.pending.find(params[:id])
  end

  def serialized_sellers
    SellerSerializer.new(@sellers || @seller).serializable_hash
  end
end
