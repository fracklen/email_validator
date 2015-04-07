require_relative 'couch_http_client'

CouchClient = CouchHttpClient.new(ENV['COUCH_URL']).client
