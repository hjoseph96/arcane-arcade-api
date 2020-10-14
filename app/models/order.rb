require 'rqrcode'

class Order < ApplicationRecord
  include QrUploader::Attachment(:qr)

  belongs_to :listing
  belongs_to :buyer, class_name: 'User', foreign_key: :buyer_id
  has_one :seller, through: :listing

  enum status: %i(in_progress unconfirmed in_escrow completed)
  enum coin_type: %w(BTC XMR)

  def listing_slug
    listing.slug
  end

  def qr_url
    qr.url
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
end
