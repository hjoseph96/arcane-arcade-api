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

  private

  def onboarding_params
    params.require(:onboarding).permit(:phase)
  end
end
