Gem::Specification.new do |s|
  s.name     = 'qu_mailer'
  s.version  = '0.2.0'
  s.platform = Gem::Platform::RUBY

  s.summary     = 'Asynchronous email delivery for ActionMailer via Qu'
  s.description = 'QuMailer is a Rails plugin for delivering email asynchronously from ActionMailer via the Qu queuing library.'

  s.homepage = 'https://github.com/pootsbook/qu_mailer'
  s.authors  = ['Philip Poots']
  s.email    = ['philip.poots@gmail.com']

  s.files         = [
    'lib/qu_mailer.rb', 
    'spec/qu_mailer_spec.rb', 
    'spec/spec_helper.rb', 
    'init.rb', 
    'Gemfile', 
    'Gemfile.lock', 
    'README.md',
    'qu_mailer.gemspec'
  ]
  s.test_files    = [
    'spec/spec_helper.rb',
    'spec/qu_mailer_spec.rb'
  ] 
  s.require_paths = ['lib']

  s.required_ruby_version = ::Gem::Requirement.new('> 1.9')

  s.add_dependency 'qu', '>= 0.1.3'
  s.add_dependency 'actionmailer', '>= 3.0.0'
  s.add_development_dependency 'rspec', '>= 2.6.0'
end
