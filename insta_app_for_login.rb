require 'sinatra'
require 'httpclient'
require 'json'
require 'uri'

class App < Sinatra::Base

	configure :development do
		enable :sessions
	end

	get "/" do
		return "<a href='/login'>instagram login</a>"
	end

	get "/login" do
		#Fixed : properties are not implicitly shared over a session
		#        need to enable session and use session variables
		#@client_id = ENV["INSTAGRAM_CLIENT_ID"]
		session[:cid] = ENV["INSTAGRAM_CLIENT_ID"]
		session[:ruri] = ENV["INSTAGRAM_REDIRECT_URI"]
	
		uri = URI.encode("https://api.instagram.com/oauth/authorize/?client_id=#{session[:cid]}&redirect_uri=#{session[:ruri]}&response_type=code&scope=basic")

		#Fixed : form does not work (I do not understand why)
		#return "<form action='#{uri}' method='get'><input type=submit>instagram login</input></form>"
		redirect uri
	end
	
	get "/redirect_from_instagram" do
		code = params["code"]
	
		client_secret = ENV["INSTAGRAM_CLIENT_SECRET"]
	
		#Comment : grant_type: authorization_code is currently the only supported value
		#          https://www.instagram.com/developer/authentication/
		query = {:client_id => session[:cid], :client_secret => client_secret, :grant_type => "authorization_code", :redirect_uri => session[:ruri], :code => code}

		#Fixed : Here post is needed instead of get
		#json = HTTPClient.new().get_content("https://api.instagram.com/oauth/access_token",query)
		json = HTTPClient.new().post_content("https://api.instagram.com/oauth/access_token",query)
		content = JSON.parse(json)
		
		#Fixed : symbols are not implicitly generated according to string keys
		#return content[:user][:id]
		return content["user"]["id"]
	end
end

App.run!

