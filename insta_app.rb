# https://www.instagram.com/developer/
#
# CLIENT ID + REDIRECT_URI => CLIENT_ID + CODE + CLIENT_SECRET => ACCESS KEY
#
# https://api.instagram.com/oauth/authorize/?client_id=CLIENT_ID&redirect_uri=http://localhost&response_type=code&scope=basic+public_content+follower_list+comments+relationships+likes
# http://localhost/?code=CODE
#
# curl -F 'client_id=CLIENT_ID' -F 'client_secret=SECRET_KEY' -F 'grant_type=authorization_code' -F 'redirect_uri=http://localhost' -F 'code=CODE' https://api.instagram.com/oauth/access_token
#{"access_token": ACCESS_TOKEN, "user": {"id": "xxxxxx", "username": "nishidy", "profile_picture": "", "full_name": "", "bio": "", "website": "", "is_business": false}}

require 'instagram'
require 'hashie'

# To disable warnings in hashie
Hashie.logger = Logger.new(nil)

client = Instagram.client( :access_token => ENV['INSTAGRAM_ACCESS_KEY'] )

client.user_recent_media.each { |media|
	puts media.caption.text unless media.caption.nil?
}

