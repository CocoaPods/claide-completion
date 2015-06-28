# encoding: utf-8
# rubocop:disable LineLength

require File.expand_path('../../spec_helper', __FILE__)

module CLAideCompletion
  describe Generator::Zsh do
    before do
      @subject = Generator::Zsh.new(Fixture::Command)
    end

    describe '::generate' do
      it 'generates an auto-completion script' do
        expected = <<-DOC.strip_margin('|')
          |#compdef bin
          |# setopt XTRACE VERBOSE
          |# vim: ft=zsh sw=2 ts=2 et
          |
          |local -a _subcommands
          |local -a _options
          |
          |case "$words[2]" in
          |  spec-file)
          |    case "$words[3]" in
          |      create)
          |        case "$words[4]" in
          |          *) # bin spec-file create
          |            _options=(
          |              "--help:Show help banner of specified command"
          |              "--no-ansi:Show output without ANSI codes"
          |              "--verbose:Show more debugging information"
          |            )
          |            _describe -t options "bin spec-file create options" _options
          |          ;;
          |        esac
          |      ;;
          |      lint)
          |        case "$words[4]" in
          |          repo)
          |            case "$words[5]" in
          |              *) # bin spec-file lint repo
          |                _options=(
          |                  "--help:Show help banner of specified command"
          |                  "--no-ansi:Show output without ANSI codes"
          |                  "--only-errors:Skip warnings"
          |                  "--verbose:Show more debugging information"
          |                )
          |                _describe -t options "bin spec-file lint repo options" _options
          |              ;;
          |            esac
          |          ;;
          |          *) # bin spec-file lint
          |            _subcommands=(
          |              "repo:Checks the validity of ALL specs in a repo."
          |            )
          |            _describe -t commands "bin spec-file lint subcommands" _subcommands
          |            _options=(
          |              "--help:Show help banner of specified command"
          |              "--no-ansi:Show output without ANSI codes"
          |              "--only-errors:Skip warnings"
          |              "--verbose:Show more debugging information"
          |            )
          |            _describe -t options "bin spec-file lint options" _options
          |          ;;
          |        esac
          |      ;;
          |      *) # bin spec-file
          |        _subcommands=(
          |          "create:Creates a spec file stub."
          |          "lint:Checks the validity of a spec file."
          |        )
          |        _describe -t commands "bin spec-file subcommands" _subcommands
          |        _options=(
          |          "--help:Show help banner of specified command"
          |          "--no-ansi:Show output without ANSI codes"
          |          "--verbose:Show more debugging information"
          |        )
          |        _describe -t options "bin spec-file options" _options
          |      ;;
          |    esac
          |  ;;
          |  *) # bin
          |    _subcommands=(
          |      "spec-file:"
          |    )
          |    _describe -t commands "bin subcommands" _subcommands
          |    _options=(
          |      "--completion-script:Print the auto-completion script"
          |      "--help:Show help banner of specified command"
          |      "--no-ansi:Show output without ANSI codes"
          |      "--verbose:Show more debugging information"
          |      "--version:Show the version of the tool"
          |    )
          |    _describe -t options "bin options" _options
          |  ;;
          |esac
        DOC
        result = @subject.generate
        expected_lines = expected.lines.to_a
        result.lines.each_with_index do |line, index|
          "#{index}:#{line}".should == "#{index}:#{expected_lines[index]}"
        end
      end
    end

    describe '::case_statement_fragment' do
      it 'returns the case statement fragment for a command' do
        expected = <<-DOC.strip_margin('|').rstrip
          |case "$words[4]" in
          |  repo)
          |    case "$words[5]" in
          |      *) # bin spec-file lint repo
          |        _options=(
          |          "--help:Show help banner of specified command"
          |          "--no-ansi:Show output without ANSI codes"
          |          "--only-errors:Skip warnings"
          |          "--verbose:Show more debugging information"
          |        )
          |        _describe -t options "bin spec-file lint repo options" _options
          |      ;;
          |    esac
          |  ;;
          |  *) # bin spec-file lint
          |    _subcommands=(
          |      "repo:Checks the validity of ALL specs in a repo."
          |    )
          |    _describe -t commands "bin spec-file lint subcommands" _subcommands
          |    _options=(
          |      "--help:Show help banner of specified command"
          |      "--no-ansi:Show output without ANSI codes"
          |      "--only-errors:Skip warnings"
          |      "--verbose:Show more debugging information"
          |    )
          |    _describe -t options "bin spec-file lint options" _options
          |  ;;
          |esac
        DOC
        result = @subject.send(:case_statement_fragment, Fixture::Command::SpecFile::Lint, 2)
        expected_lines = expected.lines.to_a
        result.lines.each_with_index do |line, index|
          "[#{index}]#{line}".should == "[#{index}]#{expected_lines[index]}"
        end
      end
    end

    describe '::case_statement_entries_fragment' do
      it 'returns the entries fragment for a case statement' do
        expected = <<-DOC.strip_margin('|')
          |repo)
          |  case "$words[5]" in
          |    *) # bin spec-file lint repo
          |      _options=(
          |        "--help:Show help banner of specified command"
          |        "--no-ansi:Show output without ANSI codes"
          |        "--only-errors:Skip warnings"
          |        "--verbose:Show more debugging information"
          |      )
          |      _describe -t options "bin spec-file lint repo options" _options
          |    ;;
          |  esac
          |;;
        DOC
        result = @subject.send(:case_statement_entries_fragment, Fixture::Command::SpecFile::Lint, 3)
        expected_lines = expected.lines.to_a
        result.lines.each_with_index do |line, index|
          "[#{index}]#{line}".should == "[#{index}]#{expected_lines[index]}"
        end
      end

      it 'generates an auto-completion script' do
        command = Fixture::Command.dup
        command.stubs(:options).returns([['--option', 'Some `code`']])
        result = @subject.class.new(command).generate
        result.should.include?('\`')
      end
    end
  end
end
