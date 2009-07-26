API_PATH = "/api"
API_HOST = "api.justin.tv"
API_PORT = 80

JTV_CONSUMER = OAuth::Consumer.new(
  ENV["JTV_CONSUMER_KEY"],
  ENV["JTV_CONSUMER_SECRET"],
  :site => "http://#{API_HOST}:#{API_PORT}",
  :http_method => :get
)