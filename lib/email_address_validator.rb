class EmailAddressValidator
  class << self
    def validate(email)
      new(email).validate
    end
  end

  def initialize(email)
    @email = email
  end

  def validate
    return failure_response(mail_failure_reason) if failed_or_bounced?
    MailServerValidator.validate(@email)
  end

  private

  def mail_failure_reason
    JSON.parse(couch_response.body)['event_type']
  end

  def failure_response(reason)
    {
      success: false,
      reason: reason
    }
  end

  def failed_or_bounced?
    couch_response.status.to_s =~ /2../
  end

  def couch_response
    @response ||= CouchClient.get("/email_addresses_rejected/#{encoded_email}")
  end

  def encoded_email
    URI.escape(@email)
  end
end
