require 'faraday'

class OrderService

  def self.create_escrow(order:, destination_address:)
    url   = "#{PAYMENT_API}/#{order.coin_type.downcase}/create"
    conn  = Faraday.new(url)

    if order.coin_type == 'XMR'
      coin_amount = to_bigint(order.coin_amount)
    else
      coin_amount = order.coin_amount
    end

    post_data = {
      expires_at: order.expires_at,
      deposit_amount: coin_amount,
      destination_address: destination_address
    }

    response = conn.post(url, post_data).body
    res = parse_response(response)

    res
  end

  def self.fetch_address(escrow_address:, coin_type:)
    url   = "#{PAYMENT_API}/#{coin_type.downcase}/find_by/#{escrow_address}"
    conn  = Faraday.new(url)

    response = parse_response(conn.get.body)
  end

  def self.crypto_full_names
    { 'btc' => 'bitcoin', 'xmr' => 'monero' }
  end

  def self.current_coin_price(fiat_currency:, coin_type:)
    CryptoConversion.convert(
      from_currency: coin_type.upcase,
      to_currency: fiat_currency,
      coin_amount: 1
    )
  end

  private

  def self.parse_response(response)
    response = JSON.parse(response, object_class: OpenStruct)
    response.status == 'success' ? response.data : false
  end

  def self.to_bigint(formatted_xmr_amount)
    formatted_xmr_amount.to_s.delete('.').to_i
  end
end
