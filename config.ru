require 'bundler'
require 'sinatra'
require 'airbrake'
require 'require_all'

require_all 'lib'
require_all 'app'

configure :production do
  require 'sinatra-logentries'
  Sinatra::Logentries.token = 'app-token'
end

configure :production do
  Airbrake.configure do |config|
    uri = URI(ENV['ERRBIT_URL'] || '')
    config.host    = uri.host
    config.api_key = uri.user
    config.secure  = uri.scheme == 'https'
    config.port    = uri.port
  end

  use Airbrake::Sinatra
end

map "/" do
  use Rack::ShowExceptions
  run Rack::Cascade.new([HealthCheckController, App])
end
