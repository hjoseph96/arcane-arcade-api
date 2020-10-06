class HomeController < ApplicationController
  def index
    render json: { welcome: 'To this api' }
  end
end
