class OrderExpiredWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'orders'

  def perform(order_id)
    order = Order.find_by(id: order_id)
    order.destroy! if order && (order.in_progress? || order.unconfirmed?) 
  end
end
