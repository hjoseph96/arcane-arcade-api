require 'faraday'

class OrderService

  def self.create_escrow(coin_type:, deposit_amount:, expires_at:)
    url   = "#{PAYMENT_API}/#{coin_type.downcase}/create"
    conn  = Faraday.new(url)

    if coin_type == 'XMR'
      coin_amount = to_bigint(deposit_amount)
    else
      coin_amount = deposit_amount
    end

    post_data = {
      expires_at: expires_at,
      deposit_amount: coin_amount
    }

    response = conn.post(url, post_data).body
    res = parse_response(response)

    res.address
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
