require './remove_stop_words'
require 'twitter'
require 'launchy'
require 'instagram'
require 'sinatra'
require 'net/http'
require 'json'



Twitter.configure do |config|
  config.consumer_key = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.oauth_token = ENV["OAUTH_TOKEN"]
  config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end

 tweets = Twitter.user_timeline("s_byrne", language:'en')
rand = Random.new.rand(tweets.length)

tweet_text = tweets[rand].text.gsub(/http\S*\b|@\S*\b|\bRT:?\b|/,'')
tweet_text_keywords = remove_stop_words(tweet_text)
puts tweet_text
puts
puts tweet_text_keywords.inspect

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





rand_keyword_1 = Random.new.rand(tweet_text_keywords.length-1)
rand_keyword_2 = Random.new.rand(tweet_text_keywords.length-1)
  while rand_keyword_1 == rand_keyword_2
    rand_keyword_2 = Random.new.rand(tweet_text_keywords.length-1)
  end

puts tweet_text_keywords[rand_keyword_1]
puts tweet_text_keywords[rand_keyword_2]


url = "http://api.giphy.com/v1/gifs/search?q=#{tweet_text_keywords[rand_keyword_1]}-#{tweet_text_keywords[rand_keyword_2]}&api_key=dc6zaTOxFJmzC&limit=5"
resp = Net::HTTP.get_response(URI.parse(url))
buffer = resp.body
result = JSON.parse(buffer)

while result["data"]==[]
  rand_keyword_1 = Random.new.rand(tweet_text_keywords.length-1)
  rand_keyword_2 = Random.new.rand(tweet_text_keywords.length-1)
  while rand_keyword_1 == rand_keyword_2
    rand_keyword_2 = Random.new.rand(tweet_text_keywords.length-1)
  end

puts tweet_text_keywords[rand_keyword_1]
puts tweet_text_keywords[rand_keyword_2]  

url = "http://api.giphy.com/v1/gifs/search?q=#{tweet_text_keywords[rand_keyword_1]}-#{tweet_text_keywords[rand_keyword_2]}&api_key=dc6zaTOxFJmzC&limit=5"
resp = Net::HTTP.get_response(URI.parse(url))
buffer = resp.body
result = JSON.parse(buffer)

end

result_url = result["data"][0]["images"]["original"]["url"]

# Launchy.open(result)

enable :sessions

CALLBACK_URL = "http://localhost:4567/oauth/callback"

# Instagram.configure do |config|
#   config.client_id = ENV["INSTA_CLIENT_ID"]
#   config.client_secret = ENV["INSTA_CLIENT_SECRET"]
# end

# results = Instagram.tag_recent_media('nintendo', 'mario', options = {count: 10})
# rand = Random.new.rand(results.length)
#   image = results[rand].images.low_resolution.url
#   tags = results[rand].tags
#   user = results[rand].user.username

get "/" do
  '<a href="/oauth/connect">Connect with Instagram</a>'
  html = "<img src=#{result_url} alt='Gosling' height='300'>"
  # html << "<h2>#{tags}</h2>"
  # html << "<h2>#{user}</h2>"
  # html << "<h2>#{tweet_text}</h2>"

  html << "<h2>#{tweets[rand].text}</h2>"
  html << "<h2>#{tweet_text_keywords}</h2>"
  html << "<h1>#{tweet_text_keywords[rand_keyword_1]}   #{tweet_text_keywords[rand_keyword_2]}"
  html << "<h2>#{JSON.parse(buffer)["data"][0]["url"]}</h2>"
end


