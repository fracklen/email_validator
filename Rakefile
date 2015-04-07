require 'rake'
require 'airbrake'
require 'require_all'
require_all 'lib'

namespace :events do
  desc 'Listen to mail events'
  task :listen do
    AMQP::MailEventListener.listen
  end
end
