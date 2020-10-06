if Rails.env === 'production'
  Rails.application.config.session_store :redis_session_store, {
    key: '_arcane_arcade_production',
    redis: {
      expire_after: 7.days,  # cookie expiration
      ttl: 7.days,           # Redis expiration, defaults to 'expire_after'
      key_prefix: 'arcane-arcade:session:',
      url: 'redis://localhost:6379/0',
    }
  }
else
  Rails.application.config.session_store :redis_session_store, {
    key: '_arcane_arcade',
    redis: {
      expire_after: 7.days,  # cookie expiration
      ttl: 7.days,           # Redis expiration, defaults to 'expire_after'
      key_prefix: 'arcane-arcade:session:',
      url: 'redis://localhost:6379/0',
    }
  }
end
