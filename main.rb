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

  {}.to_json
end

post '/move' do
  logger.info "MOVE: #{request_body.inspect}"

  content_type :json

  {
    move: Player.new(request_body, logger).move
  }.to_json
end

post '/end' do
  content_type :json

  {}.to_json
end

private

helpers do
  def request_body
    return @request_body if defined?(@request_body)
    @request_body = JSON.parse(request.body.read)
  end
end