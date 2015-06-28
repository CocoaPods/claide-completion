# encoding: utf-8

require File.expand_path('../spec_helper', __FILE__)

describe 'claide_plugin' do
  it 'should inject itself into CLAide::Command' do
    require 'claide_plugin'
    CLAide::Command.ancestors.should.include(CLAideCompletion)
  end
end
