require './syllable_count'
require 'twitter'


Twitter.configure do |config|
  config.consumer_key = ENV["CONSUMER_KEY"]
  config.consumer_secret = ENV["CONSUMER_SECRET"]
  config.oauth_token = ENV["OAUTH_TOKEN"]
  config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end

 tweets = Twitter.search("#micropoetry", count:10, language:'en').results


tweets.map do |tweet|
	if tweet.text.gsub!(/http\S*\b|@\S*\b|\bRT:?\b|/,'').syllable_count == 17  #removes anything starting with http
		puts "THIS IS A HAIKU: #{tweet.text}"
		puts
	else
		puts "NOT HAIKU: #{tweet.text}"
		puts
	end
end

#\bRT\b

