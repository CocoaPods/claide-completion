source 'https://rubygems.org'

gemspec

gem 'claide'

gem 'rake'

group :development do
  gem 'kicker'
end

group :spec do
  gem 'bacon'
  gem 'mocha-on-bacon'
  gem 'prettybacon'

  if RUBY_VERSION >= '1.9.3'
    gem 'rubocop'
    gem 'codeclimate-test-reporter', :require => nil
    gem 'simplecov'
  end
end
