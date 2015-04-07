require 'resolv'

class MailServerValidator
  class << self
    def validate(email)
      new(email).validate
    end
  end

  def initialize(email)
    @email = email
  end

  def validate
    return ok_response if lookup_mx(mail_server).any?
    check_a_record_smtp
  end

  def check_a_record_smtp
    a_records = lookup_a_records(mail_server)

    return failure_response('no_a_record') if a_records.empty?
    return failure_response('no_mail_server') unless SmtpTester.test(a_records.first)

    ok_response
  end

  private

  def ok_response
    {
      success: true
    }
  end

  def failure_response(reason)
    {
      success: false,
      reason: reason
    }
  end

  def mail_server
    @mail_server ||= @email.split('@').last
  end

  def lookup_mx(domain_name)
    Resolv::DNS.open.getresources(domain_name, Resolv::DNS::Resource::IN::MX)
  end

  def lookup_a_records(domain_name)
    Resolv::DNS.open.getresources(domain_name, Resolv::DNS::Resource::IN::A)
  end

end
