require 'json'

class App < Sinatra::Application
  HOUR = 60 * 60

  before do
    content_type 'text/json'
    cache_control :public, :must_revalidate, max_age: HOUR
  end

  get '/api/validate_email' do
    status 200
    email_address = params[:address]
    body EmailAddressValidator.validate(email_address).to_json
  end
end
