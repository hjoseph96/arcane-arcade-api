require 'faraday'

class OrderService

  def create_escrow(coin_type:, deposit_amount:, expires_at:)
    url   = "http://#{PAYMENT_API}/#{coin_type.downcase}/create"
    conn  = Faraday.new(url)

    response = conn.post("/api/v1/#{coin_typr.downcase}/create", post_data).body

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
end
