require 'bundler/setup'

require 'action_mailer'
require 'qu_mailer'

Qu::Mailer.excluded_environments = []
ActionMailer::Base.delivery_method = :test
