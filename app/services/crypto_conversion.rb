require 'faraday'

class CryptoConversion
  # TODO: Please refactor this to store the converted value somewhere
  # as right now every time we make a request it converts the same amount
  # and it slows down the listing#index response a lot
  def self.convert(coin_amount:, from_currency: 'USD', to_currency:)
    return 0 if coin_amount.to_f <= 0

    url = 'https://apiv2.bitcoinaverage.com/convert/global'
    url += "?from=#{from_currency}&to=#{to_currency}&amount=#{coin_amount}"

    conn = Faraday.new(url: url) do |f|
      f.headers['X-ba-key'] = Rails.application.credentials.BITCOIN_AVG_KEY
    end

    res = JSON.parse(conn.get.body, object_class: OpenStruct)

    res.success ?  res.price : error_msg
  end

  def self.to_bitcoin(fiat_amount, seller: current_user.seller)
    convert(
      to_currency: 'BTC',
      coin_amount: fiat_amount,
      from_currency: seller.default_currency
    )
  end

  def self.to_monero(fiat_amount, seller: current_user.seller)
    convert(
      to_currency: 'XMR',
      coin_amount: fiat_amount,
      from_currency: seller.default_currency
    )
  end

  def self.btc_to_usd(btc_amount)
    convert(
      from_currency: 'BTC', to_currency: 'USD', coin_amount: btc_amount
    )
  end

  def self.xmr_to_usd(xmr_amount)
    xmr_amount = format_xmr(xmr_amount)

    convert(
      from_currency: 'XMR', to_currency: 'USD', coin_amount: xmr_amount
    )
  end

  def self.to_default_currency(usd_amount, raw: false, user: nil)
    user ||= current_user
    raise StandardError.new('User not logged in.') unless user

    if user.default_currency == 'USD'
      return Money.new(usd_amount * 100, 'USD')
    end

    converted = Money.new(usd_amount).exchange_to(current_user.default_currency)

    raw ? converted : humanized_money_with_symbol(converted.round(2))
  end

  def self.btc_to_default_currency(btc_amount, raw: false, user: nil)
    user ||= current_user

    # convert to USD
    usd = btc_to_usd(btc_amount)

    # usd to other fiat currency
    to_default_currency(usd, raw: raw, user: user)
  end

  def self.xmr_to_default_currency(xmr_amount, raw: false, user: nil)
    user ||= current_user

    # convert to USD
    usd = xmr_to_usd(xmr_amount)

    # usd to other fiat currency
    to_default_currency(usd, raw: raw, user: user)
  end

  def self.format_xmr(xmr_amount)
    xmr = '%.12f' % xmr_amount
  end

  private

  def self.error_msg
    error_msg = 'Unable to fetch price conversion fron BitcoinAverage'
    raise StandardError.new(error_msg)
  end
end
