require 'socket'
require 'timeout'

class SmtpTester
  class << self
    def test(dns_record)
      new(dns_record).test
    end
  end

  def initialize(dns_record)
    @ip = extract_ip(dns_record)
  end

  def test
    with_timeout do
      smtp_open?
    end
  end

  private

  def extract_ip(dns_record)
    dns_record.address.to_s
  end

  def with_timeout
    begin
      Timeout::timeout(1) do
        return yield
      end
    rescue Timeout::Error
    end

    return false
  end

  def smtp_open?
    begin
      socket = TCPSocket.new(@ip, 25)
      socket.close
      return true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
      return false
    end
  end
end
