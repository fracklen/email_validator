class HealthCheckController < Sinatra::Application
  before do
    content_type 'text/plain'
    cache_control :no_cache
  end

  get '/health_check' do
    halt 500, 'NOT OK' unless couch_health
    status 200
    body 'OK'
  end

  private

  def couch_health
    CouchClient.get('/email_addresses_rejected').status.to_s =~ /2../
  rescue => e
    raise e
  end
end
