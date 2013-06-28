require './remove_stop_words'
require 'twitter'
require 'sinatra'
require 'net/http'
require 'json'
require 'launchy'
require 'rerun'



Twitter.configure do |config|
  config.consumer_key = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.oauth_token = ENV["OAUTH_TOKEN"]
  config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end
puts "What is your Twitter handle? (w/o @ symbol)"
username = gets.chomp
tweets = Twitter.user_timeline(username, language:'en')
rand = Random.new.rand(tweets.length)

puts id = tweets[rand].id
tweet_text = tweets[rand].text.gsub(/http\S*\b|@\S*\b|\bRT:?\b|/,'')
tweet_text_keywords = remove_stop_words(tweet_text)
puts tweet_text
puts
puts tweet_text_keywords.inspect
if tweet_text_keywords.length == 1 
  url= "http://api.giphy.com/v1/gifs/search?q=#{tweet_text_keywords[0]}&api_key=dc6zaTOxFJmzC&limit=5"
else
  rand_keyword_1 = Random.new.rand(tweet_text_keywords.length)
  rand_keyword_2 = Random.new.rand(tweet_text_keywords.length)
  while rand_keyword_1 == rand_keyword_2
    rand_keyword_2 = Random.new.rand(tweet_text_keywords.length)
    puts tweet_text_keywords[rand_keyword_1]
    puts tweet_text_keywords[rand_keyword_2]
  end
  url = "http://api.giphy.com/v1/gifs/search?q=#{tweet_text_keywords[rand_keyword_1]}-#{tweet_text_keywords[rand_keyword_2]}&api_key=dc6zaTOxFJmzC&limit=5"
end

resp = Net::HTTP.get_response(URI.parse(url))
buffer = resp.body
result = JSON.parse(buffer)

count = 1
while result["data"]==[] && count <= 10
  rand_keyword_1 = Random.new.rand(tweet_text_keywords.length)
  rand_keyword_2 = Random.new.rand(tweet_text_keywords.length)
  puts tweet_text_keywords[rand_keyword_1]
  puts tweet_text_keywords[rand_keyword_2]
  count +=1
  while rand_keyword_1 == rand_keyword_2
    rand_keyword_1 = Random.new.rand(tweet_text_keywords.length)
    rand_keyword_2 = Random.new.rand(tweet_text_keywords.length)
  end
  url = "http://api.giphy.com/v1/gifs/search?q=#{tweet_text_keywords[rand_keyword_1]}-#{tweet_text_keywords[rand_keyword_2]}&api_key=dc6zaTOxFJmzC&limit=5"
  resp = Net::HTTP.get_response(URI.parse(url))
  buffer = resp.body
  result = JSON.parse(buffer)

end

if count == 11
  puts "We can't find a gif for that dumb tweet."
  exit
end

result_url = result["data"][0]["images"]["original"]["url"]

# Launchy.open(result)

enable :sessions

# CALLBACK_URL = "http://localhost:4567/oauth/callback"


get "/" do
  # '<a href="/oauth/connect">Connect with Instagram</a>' 
  html = "<body style='width: 960px; margin: 20px auto; background-color: #eee'>"
  html << "<div style='margin: 20px auto; text-align: center'>"
  html << "<img style='margin: 0 auto; border: 3px solid black' src=#{result_url} alt='result_gif' height='300'>"
  html << "<h1 style='font-style: italic; margin-bottom: 100px'>#{tweets[rand].text}</h1>"
  html << "<h2>#{tweet_text_keywords}</h2>"
if tweet_text_keywords.length > 1
  html << "<h2>#{tweet_text_keywords[rand_keyword_1]}   #{tweet_text_keywords[rand_keyword_2]}</h2>"
else
  html << "<h2>#{tweet_text_keywords[0]}</h2>"
end 
  html << "<h2>#{JSON.parse(buffer)["data"][0]["url"]}</h2>"
  html << "</div>"
  html << "</body>"
end

Launchy.open("http://localhost:4567/")


