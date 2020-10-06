class V1::SellersController < ApplicationController
  before_action :authenticate
  before_action :require_seller, except: [:create]

  def show
    render_success(data: serialized_seller)
  end

  def create
    @seller = current_user.build_seller(seller_params)
    if @seller.save
      render_success(data: serialized_seller, status: :created)
    else
      render_error(model: @seller)
    end
  end

  def update
    if @seller.update(seller_params)
      render_success(data: serialized_seller)
    else
      render_error(model: @seller)
    end
  end

  private

  def require_seller
    @seller = current_user.seller
    if !@seller
      render_error(message: "Seller account not created", status: :not_found)
    end
  end

  def seller_params
    params.require(:seller).permit(
      :business_name, :studio_size, :default_currency, accepted_crypto: []
    )
  end

  def serialized_seller
    SellerSerializer.new(@seller).serializable_hash
  end

end
