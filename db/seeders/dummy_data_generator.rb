require 'faker'

class DummyDataGenerator
  attr_reader :seller_password

  def self.generate!
    new.generate
  end

  def initialize
    @seller_password = 'SellerAccount1337-'
  end

  def generate
    bandai_namco
  end

  def bandai_namco
    fake_phone = Faker::PhoneNumber.cell_phone

    user = User.create!(
      username: 'Bandai_Namco',
      email: 'admin@namco.com',
      password: @seller_password,
      password_confirmation: @seller_password,
      phone_number: fake_phone,
      seller_attributes: {
        studio_size: 'AAA',
        accepted_crypto: ['BTC'],
        business_name: 'BANDAI NAMCO Studios',
        default_currency: 'USD'
      }
    )

    puts "PUBLISHER: #{user.seller.business_name}"

    code_vein(user.seller)
  end

  def code_vein(seller)
    @listing = Listing.new(
      title: 'CODE VEIN',
      price: 59.99 * 100,
      description: Faker::Lorem.paragraph,
      seller_id: seller.id,
      release_date: Date.parse('Sep 26, 2019'),
      status: :active,
      esrb: 'MATURE'
    )

    img_path = "#{Rails.root}/db/seeders/data/bandai_namco/code_vein/*.{jpg,png}"
    video_path = "#{Rails.root}/db/seeders/data/bandai_namco/code_vein/*.{webm}"

    photos = pull_files(img_path)
    videos = pull_files(video_path)

    videos.each do |video_path|
      @listing.listing_videos.build(video: File.open(video_path))
    end

    photos.each do |img_path|
      @listing.listing_images.build(image: File.open(img_path))
    end

    @listing.categories = Category.where(title: %w(RPG Action))

    @listing.save

    puts "#{seller.business_name}: #{@listing.title} has been posted!"
  end

  def pull_files(path)
    Dir.glob(path).inject([]) {|arr, file| arr.push(file) }
  end


end
