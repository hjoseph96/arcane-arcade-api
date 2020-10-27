class V1::SellersController < ApiController
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

  def stats
    today = Date.today
    beginning_of_month = today.beginning_of_month
    end_of_month = today.end_of_month
    days_in_month = beginning_of_month..today.end_of_month
    first_week = beginning_of_month.cwday == 1 ? beginning_of_month : (beginning_of_month + 1.week).beginning_of_week

    daily_range = ((today - 6.days))..today.end_of_day
    weekly_range = (first_week..end_of_month).map{|day| day.beginning_of_week }.uniq
    monthly_range = 3.downto(0).collect {|n| n.months.ago.beginning_of_month }
    yearly_range = 11.downto(0).collect {|n| n.months.ago.beginning_of_month }

    orders = @seller.orders.completed

    daily = orders.where(created_at: daily_range).group("date_trunc('day', orders.created_at)").count

    daily_orders = {}
    daily_range.each do |item|
      utc_time = item.to_time(:utc)
      daily_orders[utc_time] = daily[utc_time] || 0
    end

    weekly = orders.where(created_at: beginning_of_month.beginning_of_day..end_of_month.end_of_day).group("date_trunc('week', orders.created_at)").count

    weekly_orders = {}
    weekly_range.each do |item|
      utc_time = item.to_time(:utc)
      weekly_orders[utc_time] = weekly[utc_time] || 0
    end

    monthly = orders.where(created_at: 4.months.ago.beginning_of_month.beginning_of_day..today.end_of_month.end_of_day).group("date_trunc('month', orders.created_at)").count

    monthly_orders = {}
    monthly_range.each do |item|
      utc_time = item.utc
      monthly_orders[utc_time] = monthly[utc_time] || 0
    end

    yearly = orders.where(created_at: 1.year.ago.beginning_of_month.beginning_of_day..today.end_of_month.end_of_day).group("date_trunc('month', orders.created_at)").count

    yearly_orders = {}
    yearly_range.each do |item|
      utc_time = item.utc
      yearly_orders[utc_time] = yearly[utc_time] || 0
    end

    @orders = orders.limit(20)

    render_success data: {
      stats: {
        daily: daily_orders,
        weekly: weekly_orders,
        monthly: monthly_orders,
        yearly: yearly_orders,
      },
      orders: serialized_orders
    }

  end

  def update
    if @seller.update(seller_params)
      render_success(data: serialized_seller)
    else
      render_error(model: @seller)
    end
  end

  def destination_addresses
    if @seller.update(destination_addresses_params)
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

  def destination_addresses_params
    params.require(:seller).permit(
      accepted_crypto: [],
      destination_addresses: [:BTC, :XMR]
    )
  end

  def seller_params
    params.require(:seller).permit(
      :business_name, :studio_size, :default_currency, accepted_crypto: []
    )
  end

  def serialized_seller
    SellerSerializer.new(@seller).serializable_hash
  end

  def serialized_orders
    OrderSerializer.new(@orders).serializable_hash
  end

end
