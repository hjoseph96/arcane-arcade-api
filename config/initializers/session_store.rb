if Rails.env === 'production'
  Rails.application.config.session_store :cookie_store, key: '_arcane_arcade_production', domain: 'arcanearcade.io'
else
  Rails.application.config.session_store :cookie_store, key: '_arcane_arcade'
end
