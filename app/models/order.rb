require 'rqrcode'

class Order < ApplicationRecord
  include QrUploader::Attachment(:qr)

  belongs_to :listing
  belongs_to :buyer, class_name: 'User', foreign_key: :buyer_id

  has_one :seller, through: :listing

  enum status: { in_progress: 0,  unconfirmed: 1, in_escrow: 2, completed: 3 }
  enum coin_type: { BTC: 0, XMR: 1}

  validates_presence_of :status, :coin_type

  before_create :setup_order

  def listing_slug
    listing.slug
  end

  def generate_qr!
    coin_name = OrderService.crypto_full_names[self.coin_type.downcase]
    url = "#{coin_name}:#{self.escrow_address}?amount=#{self.coin_amount}"
    qrcode = RQRCode::QRCode.new(url)


    png = qrcode.as_png(
      bit_depth: 2,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 400
    )

    IO.binwrite("/tmp/github-qrcode.png", png.to_s)
    self.qr = File.open ('/tmp/github-qrcode.png')

    self.save
  end

  private

  def setup_order
    self.fiat_currency = self.seller.default_currency
    self.coin_price_at_time = OrderService.current_coin_price(
      coin_type: self.coin_type,
      fiat_currency: self.fiat_currency
    )
    self.coin_amount = CryptoConversion.convert(
      to_currency: self.coin_type,
      coin_amount: self.listing.regular_price,
      from_currency: self.fiat_currency
    )
    self.expires_at = 1.hour.from_now
    destination_address = self.seller.destination_addresses[self.coin_type]
    self.escrow_address = OrderService.create_escrow(
      order: self,
      destination_address: destination_address
    )

  end
end
