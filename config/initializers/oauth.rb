Rails.application.config.middleware.use OmniAuth::Builder do
  provider :yahoo_oauth2, ENV["yahoo_client_id"], ENV["yahoo_secret"],
    name: 'yahoo'
end
