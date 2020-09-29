class V1::OnboardingController < ApplicationController
  before_action :require_login

  def show
    phase   = Rails.cache.read("ONBOARDING[#{current_user}][PHASE]")
    phase ||= 'is_seller'

    render json: { status: :ok, phase: phase }
  end

  def update
    phase = onboarding_params[:phase]

    phase = Rails.cache.write("ONBOARDING[#{current_user}][PHASE]", phase)
    render json: { status: :ok, phase: phase }
  end

  def create
    @seller = Seller.new(seller_params)
    @seller.user_id = current_user.id

    if @seller.save!
      render json: { status: :accepted, seller: @seller }
    else
      render json: {
        status: :unprocessable_entity,
        error: @seller.errors.full_messages
      }
    end
  end

  private

  def seller_params
    params.require(:seller).permit(
      :business_name, :studio_size, :default_currency, accepted_crypto: []
    )
  end

  def onboarding_params
    params.require(:onboarding).permit(:phase)
  end
end
