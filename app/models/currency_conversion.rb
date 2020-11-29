class CurrencyConversion < ApplicationRecord
  def self.convert(fiat_currency:, coin_type:, amount:)
    rates = self.first
    return 0 unless rates

    amount.to_f * rates[fiat_currency.to_s.downcase.to_sym][coin_type.to_s.upcase].to_f
  end
end
