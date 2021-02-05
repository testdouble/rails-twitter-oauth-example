require "net/http"
require "securerandom"
require "openssl"
require "base64"

module TwitterOauth
  API_HOST = "api.twitter.com"
  RequestToken = Struct.new(:oauth_token, :oauth_token_secret, :login_url, keyword_init: true)
  AccessToken = Struct.new(:oauth_token, :oauth_token_secret, :user_id, :screen_name, keyword_init: true)

  # Step 1 of:
  # https://developer.twitter.com/en/docs/authentication/guides/log-in-with-twitter
  def self.request_token
    Net::HTTP.start(API_HOST, 443, use_ssl: true) do |http|
      uri = URI("https://#{API_HOST}/oauth/request_token")
      req = Net::HTTP::Post.new(uri)
      req["Authorization"] = authorization_header(
        method: "POST",
        api_url: uri.to_s,
        auth_params: {
          oauth_callback_url: ENV["TWITTER_OAUTH_CALLBACK_URL"]
        }
      )

      res = http.request(req)
      raise "Creation of OAuth Request Token failed [HTTP Status #{res.code}]" unless res.code == "200"
      body = Rack::Utils.parse_nested_query(res.body)
      raise "Creation of OAuth Request Token failed [Internal]" unless body["oauth_callback_confirmed"] == "true"
      RequestToken.new(
        oauth_token: body["oauth_token"],
        oauth_token_secret: body["oauth_token_secret"],
        login_url: "https://twitter.com/oauth/authenticate?oauth_token=#{body["oauth_token"]}"
      )
    end
  end

  # Step 3 of:
  # https://developer.twitter.com/en/docs/authentication/guides/log-in-with-twitter
  def self.access_token(oauth_token:, oauth_token_secret:, oauth_verifier:)
    Net::HTTP.start(API_HOST, 443, use_ssl: true) do |http|
      uri = URI("https://#{API_HOST}/oauth/access_token")
      req = Net::HTTP::Post.new(uri)
      params = {
        oauth_verifier: oauth_verifier
      }
      req["Authorization"] = authorization_header(
        method: "POST",
        api_url: uri.to_s,
        oauth_token: oauth_token,
        oauth_token_secret: oauth_token_secret,
        params: params
      )
      req.set_form_data(params)

      res = http.request(req)
      raise "Creation of OAuth Access Token failed [HTTP Status #{res.code}]" unless res.code == "200"
      body = Rack::Utils.parse_nested_query(res.body)
      AccessToken.new(
        oauth_token: body["oauth_token"],
        oauth_token_secret: body["oauth_token_secret"],
        user_id: body["user_id"],
        screen_name: body["screen_name"]
      )
    end
  end

  ## Private

  # This neat method brought to you by this page:
  # https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature
  def self.authorization_header(api_url:, auth_params: {}, params: {}, method: "POST", oauth_token: nil, oauth_token_secret: nil)
    auth_hash = auth_params.merge({
      oauth_consumer_key: ENV["TWITTER_OAUTH_CONSUMER_KEY"],
      oauth_nonce: SecureRandom.base64(32),
      oauth_signature_method: "HMAC-SHA1",
      oauth_timestamp: Time.new.to_i,
      oauth_token: oauth_token,
      oauth_version: "1.0"
    }).compact.tap do |auth_hash|
      parameters = params.merge(auth_hash).map { |k, v|
        [encode(k), encode(v)]
      }.sort.map { |k, v|
        "#{k}=#{v}"
      }.join("&")
      signature_base = method.upcase + "&" + encode(api_url) + "&" + encode(parameters)
      signing_key = encode(ENV["TWITTER_OAUTH_CONSUMER_SECRET"]) + "&" + encode(oauth_token_secret)

      auth_hash[:oauth_signature] = sign(key: signing_key, data: signature_base)
    end

    "OAuth " + auth_hash.map { |k, v|
      "#{encode(k)}=\"#{encode(v)}\""
    }.join(", ")
  end

  def self.encode(s)
    URI.encode_www_form_component(s)
  end

  def self.sign(key:, data:)
    Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("SHA1"), key, data)).chomp
  end
end
