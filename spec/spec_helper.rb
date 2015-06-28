# encoding: utf-8

if RUBY_VERSION >= '1.9.3'
  require 'codeclimate-test-reporter'

  CodeClimate::TestReporter.configure do |config|
    config.logger.level = Logger::WARN
  end

  CodeClimate::TestReporter.start
end

#-----------------------------------------------------------------------------#

require 'pathname'
ROOT = Pathname.new(File.expand_path('../../', __FILE__))
$LOAD_PATH.unshift((ROOT + 'lib').to_s)
$LOAD_PATH.unshift((ROOT + 'spec').to_s)

require 'bundler/setup'
require 'bacon'
require 'mocha-on-bacon'
require 'pretty_bacon'
require 'claide'
require 'claide_completion'

require 'spec_helper/fixtures'
