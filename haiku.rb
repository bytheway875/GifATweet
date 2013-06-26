require './syllable_count'
require 'twitter'
require 'flickraw'
require 'launchy'
require 'instagram'
require 'sinatra'


Twitter.configure do |config|
  config.consumer_key = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.oauth_token = ENV["OAUTH_TOKEN"]
  config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end

 tweets = Twitter.search("#micropoetry", count:10, language:'en').results
rand = Random.new.rand(tweets.length)

tweet_text = tweets[rand].text.gsub!(/http\S*\b|@\S*\b|\bRT:?\b|/,'')

# tweets.map do |tweet|
#  tweet.text.gsub!(/http\S*\b|@\S*\b|\bRT:?\b|/,'')#.syllable_count == 17  #removes anything starting with http
# end

#\bRT\b

# #flickraw
# FlickRaw.api_key=ENV["FLICKR_KEY"]
# FlickRaw.shared_secret=ENV["FLICKR_SHARED_SECRET"]

# results = flickr.photos.search(text: "square", per_page: 10)
# rand = Random.new.rand(results.length)
#   info = flickr.photos.getInfo(photo_id: results[rand].id)
#   url = FlickRaw.url_m(info)
# Launchy.open(url)
  # puts "http://farm#{result.farm-id}.staticflickr.com/#{result.server-id}/#{result.id}_#{result.secret}.jpg"

# Instagram.configure do |config|
#   config.client_id = ENV["INSTA_CLIENT_ID"]
#   config.client_secret = ENV["INSTA_CLIENT_SECRET"]
# end

# results = Instagram.tag_recent_media('volcano', options = {count: 10})
# rand = Random.new.rand(results.length)
#   image = results[rand].images.low_resolution.url
# Launchy.open(image)


enable :sessions

CALLBACK_URL = "http://localhost:4567/oauth/callback"

Instagram.configure do |config|
  config.client_id = ENV["INSTA_CLIENT_ID"]
  config.client_secret = ENV["INSTA_CLIENT_SECRET"]
end

results = Instagram.tag_recent_media('nintendo', 'mario', options = {count: 10})
rand = Random.new.rand(results.length)
  image = results[rand].images.low_resolution.url
  tags = results[rand].tags
  user = results[rand].user.username

get "/" do
  '<a href="/oauth/connect">Connect with Instagram</a>'
  html = "<img src='#{image}'>"
  html << "<h2>#{tags}</h2>"
  html << "<h2>#{user}</h2>"
  html << "<h2>#{tweet_text}</h2>"

  html
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/feed"
end

get "/feed" do
  client = Instagram.client(:access_token => session[:access_token])
  user = client.user

  html = "<h1>Test recent photos</h1>"
  html << "<p>This is a test</p>"
  html
end