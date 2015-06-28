# encoding: utf-8

require File.expand_path('../spec_helper', __FILE__)

module CLAideCompletion
  describe Generator do
    before do
      @subject = Generator
    end

    describe '::generate' do
      it 'returns the completion helper for the given shell' do
        result = @subject.generate(Fixture::Command, 'zsh')
        result.should.start_with?('#compdef bin')
      end

      it 'infers the given shell is one is not provided' do
        ENV.stubs(:[]).with('SHELL').returns('zsh')
        @subject::Zsh.any_instance.expects(:generate).once
        @subject.generate(Fixture::Command)
      end

      it 'raises if unable to support the shell' do
        should.raise Generator::ShellCompletionNotFound do
          @subject.generate(Fixture::Command, 'heheshell!')
        end.message.should.include?('shell is not implemented')
      end
    end

    describe '::indent' do
      it 'indents the given string by the given amount' do
        @subject.indent("line 1\nline 2", 1).should == "line 1\n  line 2"
      end

      it 'it does not indent the first line' do
        @subject.indent("line 1\nline 2", 1).should.start_with?('line 1')
      end
    end
  end
end
