require 'base64'

class TokenRefresher

  def self.refresh(user)
    oauth_client = OAuth2::Client.new(ENV['yahoo_client_id'], ENV['yahoo_secret'], {
      site: 'https://api.login.yahoo.com',
      authorize_url: '/oauth2/request_auth',
      token_url: '/oauth2/get_token',
    })

    auth = "Basic #{Base64.strict_encode64("#{ENV['yahoo_client_id']}:#{ENV['yahoo_secret']}")}"

    new_token = oauth_client.get_token({
      redirect_uri: '/yahoo/refresh/callback',
      refresh_token: user.refresh_token,
      grant_type: 'refresh_token',
      headers: { 'Authorization' => auth } })
    user.update_attributes(token: new_token.token)
  end
end
