require 'require_all'
require_all 'lib'

RSpec.describe MailServerValidator do
  let(:ok_response) do
    {
      success: true
    }
  end

  let(:failure_no_a_record) do
    {
      success: false,
      reason: 'no_a_record'
    }
  end

  let(:failure_no_mail_server) do
    {
      success: false,
      reason: 'no_mail_server'
    }
  end

  it "validates gmail" do
    expect(MailServerValidator.validate('test@gmail.com')).to eq ok_response
  end

  it "detects mail server" do
    expect(MailServerValidator.validate('test@mail4.gandi.net')).to eq ok_response
  end

  it "detects no_mail_server" do
    expect(MailServerValidator.validate('test@foobar.ph')).to eq failure_no_mail_server
  end

  it "detects no_a_record" do
    expect(MailServerValidator.validate('test@f.o.o.b.a.r')).to eq failure_no_a_record
  end
end
