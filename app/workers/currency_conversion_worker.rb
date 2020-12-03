
class CurrencyConversionWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'currency'

  def perform
    CryptoConversion.update
  end
end
