class HomeController < ApiController
  def index
    render json: { welcome: 'To this api' }
  end
end
