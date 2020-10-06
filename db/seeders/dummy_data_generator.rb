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
    naruto(user.seller)
    dragon_ball(user.seller)
    dark_souls(user.seller)
  end

  def code_vein(seller)
    @listing = Listing.new(
      title: 'CODE VEIN',
      price: 59.99 * 100,
      seller_id: seller.id,
      release_date: Date.parse('Sep 26, 2019'),
      status: :active,
      esrb: 'MATURE'
    )

    photos = pull_images('code_vein')
    videos = pull_videos('code_vein')

    videos.each do |video_path|
      @listing.listing_videos.build(video: File.open(video_path))
    end

    photos.each do |img_path|
      @listing.listing_images.build(image: File.open(img_path))
    end

    @listing.categories = Category.where(title: %w(RPG Action))
    @listing.save
    @listing.description = "<p>#{Faker::Lorem.unique.paragraphs(number: 30).join(' ')}</p>",
    @listing.save


    puts "#{seller.business_name}: #{@listing.title} has been posted!"
  end

  def naruto(seller)
    @listing = Listing.new(
      title: 'NARUTO SHIPPUDEN: Ultimate Ninja STORM 4',
      price: 29.99 * 100,
      seller_id: seller.id,
      release_date: Date.parse('Feb 4, 2016'),
      status: :active,
      esrb: 'TEEN'
    )


    photos = pull_images('naruto')
    videos = pull_videos('naruto')

    videos.each do |video_path|
      @listing.listing_videos.build(video: File.open(video_path))
    end

    photos.each do |img_path|
      @listing.listing_images.build(image: File.open(img_path))
    end

    @listing.categories = Category.where(title: %w(Action Adventure))

    @listing.save
    @listing.description = "<p>#{Faker::Lorem.unique.paragraphs(number: 30).join(' ')}</p>",
    @listing.save


    puts "#{seller.business_name}: #{@listing.title} has been posted!"
  end

  def dragon_ball(seller)
    @listing = Listing.new(
      title: 'DRAGON BALL FighterZ',
      price: 59.99 * 100,
      seller_id: seller.id,
      release_date: Date.parse('Jan 26, 2018'),
      status: :active,
      esrb: 'TEEN'
    )

    photos = pull_images('dbz')
    videos = pull_videos('dbz')

    videos.each do |video_path|
      @listing.listing_videos.build(video: File.open(video_path))
    end

    photos.each do |img_path|
      @listing.listing_images.build(image: File.open(img_path))
    end

    @listing.categories = Category.where(title: %w(Action Adventure))

    @listing.save
    @listing.description = "<p>#{Faker::Lorem.unique.paragraphs(number: 30).join(' ')}</p>",
    @listing.save


    puts "#{seller.business_name}: #{@listing.title} has been posted!"
  end


  def dark_souls(seller)
    @listing = Listing.new(
      title: 'DARK SOULS™ III',
      price: 59.99 * 100,
      seller_id: seller.id,
      release_date: Date.parse('Apr 11, 2016'),
      status: :active,
      esrb: 'MATURE'
    )

    photos = pull_images('dark_souls')
    videos = pull_videos('dark_souls')

    videos.each do |video_path|
      @listing.listing_videos.build(video: File.open(video_path))
    end

    photos.each do |img_path|
      @listing.listing_images.build(image: File.open(img_path))
    end

    @listing.categories = Category.where(title: 'Action')

    @listing.save

    @listing.description = "<p>#{Faker::Lorem.unique.paragraphs(number: 30).join(' ')}</p>",
    @listing.save


    puts "#{seller.business_name}: #{@listing.title} has been posted!"
  end


  def pull_images(folder)
    img_path = "#{Rails.root}/db/seeders/data/bandai_namco/#{folder}/*.{jpg,png}"
    Dir.glob(img_path).inject([]) {|arr, file| arr.push(file) }
  end

  def pull_videos(folder)
    video_path = "#{Rails.root}/db/seeders/data/bandai_namco/#{folder}/*.{webm}"
    Dir.glob(video_path).inject([]) {|arr, file| arr.push(file) }
  end

end
