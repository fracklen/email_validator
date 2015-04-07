require 'faraday'
require 'uri'

class CouchHttpClient
  def initialize(base_url)
    @base_url = base_url
  end

  def client
    @conn ||= Faraday.new(url: @base_url) do |faraday|
      faraday.request :url_encoded
      faraday.adapter :excon
      faraday.basic_auth uri.user, uri.password unless uri.user.nil?
    end
  end

  private

  def uri
    URI(@base_url || '')
  end
end
