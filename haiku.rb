require './syllable_count'
require 'twitter'
require 'flickraw'
require 'launchy'
require 'instagram'


Twitter.configure do |config|
  config.consumer_key = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.oauth_token = ENV["OAUTH_TOKEN"]
  config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end

 tweets = Twitter.search("#micropoetry beaver", count:10, language:'en').results


tweets.map do |tweet|
 tweet.text.gsub!(/http\S*\b|@\S*\b|\bRT:?\b|/,'')#.syllable_count == 17  #removes anything starting with http
end

#\bRT\b

#flickraw
FlickRaw.api_key=ENV["FLICKR_KEY"]
FlickRaw.shared_secret=ENV["FLICKR_SHARED_SECRET"]

results = flickr.photos.search(text: "square", per_page: 10)
rand = Random.new.rand(results.length)
  info = flickr.photos.getInfo(photo_id: results[rand].id)
  url = FlickRaw.url_m(info)
Launchy.open(url)
  # puts "http://farm#{result.farm-id}.staticflickr.com/#{result.server-id}/#{result.id}_#{result.secret}.jpg"

Instagram.configure do |config|
  config.client_id = ENV["INSTA_CLIENT_ID"]
  config.client_secret = ENV["INSTA_CLIENT_SECRET"]

