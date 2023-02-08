require 'dotenv/load'
require 'sinatra'
require 'json'

require './lib/player'

set :bind, '0.0.0.0'
set :port, 80

get '/' do
  content_type :json

  {
    "apiversion": "1",
    "author": ENV.fetch('AUTHOR'),
    "color": ENV.fetch('COLOR'),
    "head": ENV.fetch('HEAD', 'default'),
    "tail": ENV.fetch('TAIL', 'default'),
    "version": ENV.fetch('VERSION', '0.1')
  }.to_json
end

post '/start' do
  content_type :json

  response = {}
  log(:start, response)

  response.to_json
end

post '/move' do
  content_type :json

  response = Player.new(request_body, logger).play
  log(:move, response)

  response.to_json
end

post '/end' do
  content_type :json

  response = {}
  log(:end, reponse)

  response.to_json
end

private

helpers do
  def log(label, response_body)
    data = {
      request: request_body,
      response: response_body
    }.to_json

    logger.info("#{label.to_s.upcase}: #{data}")

    Dir.mkdir('./log') unless Dir.exist?('./log')
    filename = "./log/#{request_body['game']['id']}.jsonl"

    File.open(filename, 'a'){ |f| f.puts data }
  end

  def request_body
    return @request_body if defined?(@request_body)
    @request_body = JSON.parse(json_body)
  end

  def json_body
    return @json_body if defined?(@json_body)
    @json_body = request.body.read
  end
end