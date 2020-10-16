require 'rqrcode'

class Order < ApplicationRecord
  include QrUploader::Attachment(:qr)

  belongs_to :listing
  belongs_to :buyer, class_name: 'User', foreign_key: :buyer_id

  attribute :platform, :string

  has_one :seller, through: :listing
  has_one :owned_game, dependent: :destroy

  enum status: { in_progress: 0,  unconfirmed: 1, in_escrow: 2, completed: 3 }
  enum coin_type: { BTC: 0, XMR: 1}

  accepts_nested_attributes_for :owned_game, update_only: true


  validates_presence_of :status, :coin_type, :owned_game

  validates :platform, presence: true, on: :create

  before_validation :set_owned_game
  before_create :setup_order
  before_create :generate_qr

  def listing_slug
    listing.slug
  end

  def paid!
    self.status = :completed
    self.owned_game.status = :active
    self.save!
  end

  private

  def set_owned_game
    return if self.owned_game
    if self.listing && self.buyer
      platform_listing = self.listing.
        supported_platform_listings.
        includes(:supported_platform).
        find_by(
          supported_platforms: {
            name: self.platform
          }
        )
      self.build_owned_game(
        user: self.buyer,
        supported_platform_listing: platform_listing
      )
    end
  end

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
    unless self.escrow_address
      self.errors.add(:base, 'Something went wrong, please try again')
      throw :abort
    end
  end

  def generate_qr
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

    self.qr = StringIO.new(png.to_s)
  end

end
