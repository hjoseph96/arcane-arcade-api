if Rails.env === 'production'
  Rails.application.config.session_store :cookie_store, key: '_arcane_arcade_production', domain: 'arcanearcade.io'
  config.middleware.use ActionDispatch::Cookies # Required for all session management
  config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
else
  Rails.application.config.session_store :cookie_store, key: '_arcane_arcade'
end
