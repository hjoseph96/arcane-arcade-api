require "#{Rails.root}/db/seeders/supported_platform_generator"
require "#{Rails.root}/db/seeders/dummy_data_generator"
require "#{Rails.root}/db/seeders/category_generator"
require "#{Rails.root}/db/seeders/tag_generator"

SupportedPlatformGenerator.generate!
CategoryGenerator.generate!
TagGenerator.generate!
