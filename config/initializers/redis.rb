if Rails.env == 'production'
	if ENV["STAGING"] == 'true'
  		uri = URI.parse("redis://redistogo:a3e5956eb98cbcac6f805497619dff58@soldierfish.redistogo.com:10467")
  	elsif Rails.env.production?
  		uri = URI.parse("redis://redistogo:72b1db62bfb943bf919e4ab373ab5151@soldierfish.redistogo.com:10581")
  	end
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end