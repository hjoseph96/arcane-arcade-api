require "shrine"
require "shrine/storage/file_system"
require "shrine/storage/s3"

if Rails.env.development? || Rails.env.test

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(
      bucket: 'arcane-arcade-development', # required
      region: 'us-east-1', # required
      prefix: 'uploads/cache',
      access_key_id: Rails.application.credentials.AWS_ACCESS_ID,
      secret_access_key: Rails.application.credentials.AWS_SECRET,
    ), # temporary
    store: Shrine::Storage::S3.new(
      bucket: 'arcane-arcade-development', # required
      region: 'us-east-1', # required
      prefix: 'uploads',
      access_key_id: Rails.application.credentials.AWS_ACCESS_ID,
      secret_access_key: Rails.application.credentials.AWS_SECRET,
    )       # permanent
  }
elsif Rails.env.production?
  Shrine.storages = {
    cache: Shrine::Storage::S3.new(
      bucket: 'arcanearcadeproduction', # required
      region: 'us-east-1', # required
      prefix: 'uploads/cache',
      access_key_id: Rails.application.credentials.AWS_ACCESS_ID,
      secret_access_key: Rails.application.credentials.AWS_SECRET,
    ), # temporary
    store: Shrine::Storage::S3.new(
      bucket: 'arcanearcadeproduction', # required
      region: 'us-east-1', # required
      prefix: 'uploads',
      access_key_id: Rails.application.credentials.AWS_ACCESS_ID,
      secret_access_key: Rails.application.credentials.AWS_SECRET,
    )       # permanent
  }
end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file


# Google::Cloud::Storage.configure do |config|
#   config.project_id  = "arcane-arcade"
#   config.credentials = "#{Rails.root}/arcane_arcade_google.json"
# end
#
# Shrine.storages = {
#   cache: Shrine::Storage::GoogleCloudStorage.new(bucket: "cache"),
#   store: Shrine::Storage::GoogleCloudStorage.new(
#     bucket: "arcane_arcade_development",
#     default_acl: 'publicRead',
#     object_options: {
#       cache_control: 'public, max-age: 7200'
#     },
#   )
# }