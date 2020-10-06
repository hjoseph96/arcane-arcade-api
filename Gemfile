source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.3'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# Use Puma as the app server
gem 'puma', '~> 4.1'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'sorcery'
gem 'pretender'
gem 'shrine'
gem 'money'
gem 'countries'
gem 'faraday'
gem 'mailgun'
gem 'mini_magick'
gem 'oj'
gem 'kaminari'
gem 'sidekiq'
gem 'ancestry'
gem 'searchkick'
gem 'streamio-ffmpeg'
gem 'twilio-ruby'
gem 'redis-rails'
gem 'fast_jsonapi'
gem 'aws-sdk-s3', '~> 1.14'
gem 'friendly_id', '~> 5.4.0'
gem 'rqrcode'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS)
gem 'rack-cors'

group :development, :test do
  gem 'bullet'
  gem 'brakeman'
  gem 'faker'
  gem 'pry-rails'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "rubocop", "~> 0.70.0", require: false
  gem "rspec-rails", "~> 3.8"
end

group :test do
end


group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
