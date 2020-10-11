class SupportedPlatformGenerator
  def self.generate!
    new.generate!
  end

  def generate!
    pc    = SupportedPlatform.create!(name: 'PC')
    puts "Supported Platform: 'PC' has been created."

    win   = SupportedPlatform.create!(name: 'WINDOWS', parent_id: pc.id)
    puts "Supported Platform: 'WINDOWS' has been created."

    mac   = SupportedPlatform.create!(name: 'MAC', parent_id: pc.id)
    puts "Supported Platform: 'MAC' has been created."

    linux = SupportedPlatform.create!(name: 'LINUX', parent_id: pc.id)
    puts "Supported Platform: 'LINUX' has been created."

    console = SupportedPlatform.create!(name: 'CONSOLE')

    SupportedPlatform.create!(name: 'XB1', parent_id: console.id)
    puts "Supported Platform: 'XB1' has been created."

    SupportedPlatform.create!(name: 'PS4', parent_id: console.id)
    puts "Supported Platform: 'PS4' has been created."

    SupportedPlatform.create!(name: 'SWITCH', parent_id: console.id)
    puts "Supported Platform: 'SWITCH' has been created."
  end

end
