require 'faker'

class DummyDataGenerator
  attr_reader :seller_password

  def self.generate!
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
      phone_number: fake_phone,
      seller_attributes: {
        studio_size: 'AAA',
        accepted_crypto: ['BTC'],
        business_name: 'BANDAI NAMCO Studios',
        default_currency: 'USD'
      }
    )
  end


end
